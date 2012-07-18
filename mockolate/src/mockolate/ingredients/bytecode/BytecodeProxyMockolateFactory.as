package mockolate.ingredients.bytecode
{
	import asx.array.forEach;
	import asx.array.repeat;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import mockolate.ingredients.AbstractMockolateFactory;
	import mockolate.ingredients.ClassRecipe;
	import mockolate.ingredients.ClassRecipes;
	import mockolate.ingredients.IMockolateFactory;
	import mockolate.ingredients.InstanceRecipe;
	import mockolate.ingredients.InstanceRecipes;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.mockolate_ingredient;
	
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.ProxyScope;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.*;
	import org.as3commons.logging.setup.target.*;
	
	use namespace mockolate_ingredient;

	public class BytecodeProxyMockolateFactory extends AbstractMockolateFactory implements IMockolateFactory
	{
		private static function getDefinitionByNameSafely(name:String):Object 
		{
			try
			{
				return getDefinitionByName(name);	
			}
			catch (e:Error)
			{
				// ignored.
			}
			
			return null;
		} 

		private static var _applicationDomain:ApplicationDomain;

		// this is gross. -drew
		// this is really gross -drew, 20110512
		private static const loaded:Boolean = (function():Boolean 
		{
			// Try to get FlexGlobals
			var FlexGlobals:Object = getDefinitionByNameSafely("mx.core.FlexGlobals");
			if (FlexGlobals)
			{
				_applicationDomain = FlexGlobals.topLevelApplication.loaderInfo.applicationDomain;

				ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo, _applicationDomain);
				return true;
			}
			
			// Otherwise try to get Application
			var Application:Object = getDefinitionByNameSafely("mx.core.Application");
			if (Application)
			{
				_applicationDomain = Application.application.loaderInfo.applicationDomain;

				ByteCodeType.fromLoader(Application.application.loaderInfo, _applicationDomain);
				return true;
			}
			
			return false;
		})();
		
		private var _mockolatier:Mockolatier;
		private var _proxyInfoByClassRecipe:Dictionary;
		private var _classRecipeByProxyInfo:Dictionary;
		private var _proxyFactoryByClass:Dictionary;
		private var _proxyFactory:IProxyFactory;
		
		/**
		 * Constructor.
		 */
		public function BytecodeProxyMockolateFactory(mockolatier:Mockolatier, applicationDomain:ApplicationDomain = null)
		{
			super();
			
			_mockolatier = mockolatier;
			_proxyInfoByClassRecipe = new Dictionary();
			_proxyFactoryByClass = new Dictionary();
			_proxyFactory = new ProxyFactory();

			LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget );			
		}
		
		public function prepareClasses(classRecipes:ClassRecipes):IEventDispatcher
		{
			var bridge:IEventDispatcher = new EventDispatcher();
			
			if (classRecipes.numRecipes == 0)
			{
				setTimeout(bridge.dispatchEvent, 0, new Event(Event.COMPLETE));
				return bridge;
			}

			var proxyFactory:IProxyFactory = new ProxyFactory();
			
			trace('BytecodeProxyMockolateFactory prepareClasses');

			for each (var classRecipe:ClassRecipe in classRecipes.toArray())
			{
				trace('\t', classRecipe.classToPrepare);
				trace('\t', (classRecipe.namespacesToProxy || []).join(', ') );

				_proxyFactoryByClass[classRecipe.classToPrepare] = proxyFactory;

				var proxyInfo:IClassProxyInfo = proxyFactory.defineProxy(classRecipe.classToPrepare, BytecodeProxyInterceptor, _applicationDomain);
				// default to only proxy public methods and accessors.
				proxyInfo.proxyMethodScopes = ProxyScope.PUBLIC;
				proxyInfo.proxyAccessorScopes = ProxyScope.PUBLIC;
				// also proxy namespace methods and accessors if namespaces we given.
				if (classRecipe.namespacesToProxy) {
					proxyInfo.proxyMethodNamespaces = classRecipe.namespacesToProxy.slice();
					proxyInfo.proxyAccessorNamespaces = classRecipe.namespacesToProxy.slice();
				}
			}
			
			proxyFactory.addEventListener(Event.COMPLETE, function(event:Event):void {
				trace('\t', 'COMPLETE');

				for each (var classRecipe:ClassRecipe in classRecipes.toArray()) 
				{
					var proxyFactory:IProxyFactory = _proxyFactoryByClass[classRecipe.classToPrepare];

					classRecipe.proxyClass = proxyFactory.getProxyInfoForClass(classRecipe.classToPrepare).proxyClass;
				}


				proxyFactory.removeEventListener(Event.COMPLETE, arguments.callee);
				bridge.dispatchEvent(new Event(Event.COMPLETE));
			});
			
			try 
			{
				proxyFactory.generateProxyClasses();
				proxyFactory.loadProxyClasses(_applicationDomain);
			}
			catch (error:Error)
			{
				trace('\t', 'ERROR', error, error.getStackTrace());
				setTimeout(bridge.dispatchEvent, 0, new Event(Event.COMPLETE));
			}
			
			return bridge;
		}
		
		public function prepareInstances(instanceRecipes:InstanceRecipes):IEventDispatcher
		{
			var bridge:IEventDispatcher = new EventDispatcher();
			
			forEach(instanceRecipes.toArray(), prepareInstance);
			
			setTimeout(bridge.dispatchEvent, 0, new Event(Event.COMPLETE));
			
			return bridge;
		}
		
		public function prepareInstance(instanceRecipe:InstanceRecipe):InstanceRecipe
		{
			if (instanceRecipe)
			{
				instanceRecipe.mockolate = createMockolate(instanceRecipe);
				instanceRecipe.instance = createInstance(instanceRecipe);
				instanceRecipe.mockolate.target = instanceRecipe.instance;
				instanceRecipe.mockolate.targetClass = instanceRecipe.classRecipe.classToPrepare;
			}
			
			return instanceRecipe;
		}
		
		private function createMockolate(instanceRecipe:InstanceRecipe):Mockolate
		{
			var mockolateInstance:BytecodeProxyMockolate = new BytecodeProxyMockolate(instanceRecipe.name);
			mockolateInstance.mockType = instanceRecipe.mockType;
			mockolateInstance.interceptor = createInterceptor(mockolateInstance);
			mockolateInstance.recorder = createRecorder(mockolateInstance);
			mockolateInstance.mocker = createMocker(mockolateInstance);
			mockolateInstance.verifier = createVerifier(mockolateInstance);
			mockolateInstance.expecter = createExpecter(mockolateInstance);
			return mockolateInstance;
		}
		
		private function createInstance(instanceRecipe:InstanceRecipe):*
		{
			var proxyFactory:IProxyFactory = _proxyFactoryByClass[instanceRecipe.classRecipe.classToPrepare];

			function injectInterceptor(event:ProxyFactoryEvent):void 
			{
				event.methodInvocationInterceptor = createInterceptor(instanceRecipe.mockolate);

				proxyFactory.removeEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, injectInterceptor);
			}

			trace('BytecodeProxyMockolateFactory createInstance', instanceRecipe);
			
			proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, injectInterceptor);

			var targetInstance:* = proxyFactory.createProxy(instanceRecipe.classRecipe.classToPrepare, constructorArgumentsFor(instanceRecipe));
			
			return targetInstance;
		}
		
		private function createInterceptor(mockolate:Mockolate):IMethodInvocationInterceptor
		{
			return new BytecodeProxyInterceptor(mockolate, _mockolatier);
		}
		
		private function constructorArgumentsFor(instanceRecipe:InstanceRecipe):Array 
		{
			var constructorArgs:Array;
			
			if (instanceRecipe.constructorArgsFunction is Function)
			{
				constructorArgs = instanceRecipe.constructorArgsFunction() as Array;
			}
			else if (instanceRecipe.constructorArgs is Array)
			{
				constructorArgs = instanceRecipe.constructorArgs;
			}
			
			if (!constructorArgs)
			{
				var instanceClassRecipe:ClassRecipe = instanceRecipe.classRecipe;
				var classToPrepare:Class = instanceClassRecipe.classToPrepare;
				var bytecodeType:ByteCodeType = ByteCodeType.forClass(classToPrepare, _applicationDomain);
				var constructor:* = bytecodeType.constructor;
				var parameters:* = constructor.parameters;
				var numParameters:* = parameters.length;

				constructorArgs = repeat(null, numParameters);
			}
			
			return constructorArgs;
		}
	}
}