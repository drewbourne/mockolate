package mockolate.ingredients.bytecode
{
	import asx.array.filter;
	import asx.array.forEach;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import mockolate.ingredients.AbstractMockolateFactory;
	import mockolate.ingredients.MockType;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.mockolate_ingredient;
	
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryEvent;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	
	use namespace mockolate_ingredient;

	public class BytecodeProxyMockolateFactory extends AbstractMockolateFactory // implements IMockolateFactory
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

		// this is gross. -drew
		// this is really gross -drew, 20110512
		private static const loaded:Boolean = (function():Boolean 
		{
			// Try to get FlexGlobals
			var FlexGlobals:Object = getDefinitionByNameSafely("mx.core.FlexGlobals");
			if (FlexGlobals)
			{
				ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo);
				return true;
			}
			
			// Otherwise try to get Application
			var Application:Object = getDefinitionByNameSafely("mx.core.Application");
			if (Application)
			{
				ByteCodeType.fromLoader(Application.application.loaderInfo);
				return true;
			}
			
			return false;
		})();
		
		private var _proxyFactory:IProxyFactory;
		private var _mockolatier:Mockolatier;
		private var _applicationDomain:ApplicationDomain;
		private var _preparedClasses:Dictionary;
		
		/**
		 * Constructor.
		 */
		public function BytecodeProxyMockolateFactory(mockolatier:Mockolatier, applicationDomain:ApplicationDomain = null)
		{
			super();
			
			_mockolatier = mockolatier;
			_applicationDomain = applicationDomain || new ApplicationDomain(ApplicationDomain.currentDomain);
			_proxyFactory = new ProxyFactory();
			_preparedClasses = new Dictionary();
		}
		
		/**
		 * @inheritDoc
		 */
		public function prepare(...rest):IEventDispatcher
		{
			var classesToPrepare:Array = filter(rest, function(classReference:Class):Boolean { 
				return _preparedClasses[classReference] == null;
			});
			
			forEach(classesToPrepare, function(classReference:Class):void {
				var proxyInfo:IClassProxyInfo = _proxyFactory.defineProxy(classReference, BytecodeProxyInterceptor);
				_preparedClasses[classReference] = proxyInfo;				
			});

			if (classesToPrepare.length > 0)
			{
				_proxyFactory.generateProxyClasses();
				_proxyFactory.loadProxyClasses(_applicationDomain);
				return _proxyFactory;
			}
			else 
			{
				var eventDispatcher:IEventDispatcher = new EventDispatcher();
				setTimeout(eventDispatcher.dispatchEvent, 0, new Event(Event.COMPLETE));
				return eventDispatcher;  				
			}
		}
		
		public function prepareClasses(toPrepare:Array):IEventDispatcher
		{
			throw new Error("prepareClasses not implemented");	
		}
		
		public function prepareClassWithNamespaces(classReference:Class, namespacesToProxy:Array):IEventDispatcher
		{
			throw new Error("prepareClassWithNamespaces not implemented");	
		}
		
		public function preparedClassFor(classReference:Class, proxiedNamespaces:Array = null):Class
		{
			throw new Error("prepareClassWithNamespaces not implemented");	
		}
		
		/**
		 * @inheritDoc
		 */
		public function create(mockType:MockType, classReference:Class, constructorArgs:Array=null, name:String=null):Mockolate
		{
			var mockolateInstance:BytecodeProxyMockolate = createMockolate(name);
			mockolateInstance.mockType = mockType;
			mockolateInstance.targetClass = classReference;
			
			function injectInterceptor(event:ProxyFactoryEvent):void 
			{
				event.methodInvocationInterceptor = mockolateInstance.interceptor;				
			}
			
			_proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, injectInterceptor);
			mockolateInstance.target = _proxyFactory.createProxy(classReference, constructorArgs || []);
			_proxyFactory.removeEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, injectInterceptor);
			return mockolateInstance;
		}
		
		/**
		 * @private 
		 */
		public function createWithProxyClass(mockType:MockType, classReference:Class, proxyClass:Class, constructorArgs:Array=null, name:String=null):Mockolate
		{
			throw new Error("Not implemented");
		}
		
		/**
		 * @private 
		 */
		protected function createMockolate(name:String=null):BytecodeProxyMockolate
		{
			var mockolateInstance:BytecodeProxyMockolate = new BytecodeProxyMockolate(name);
			mockolateInstance.interceptor = createInterceptor(mockolateInstance);
			mockolateInstance.recorder = createRecorder(mockolateInstance);
			mockolateInstance.mocker = createMocker(mockolateInstance);
			mockolateInstance.verifier = createVerifier(mockolateInstance);
			mockolateInstance.expecter = createExpecter(mockolateInstance);
			return mockolateInstance;
		}
		
		/**
		 * @private 
		 */
		protected function createInterceptor(mockolate:Mockolate):IMethodInvocationInterceptor
		{
			return new BytecodeProxyInterceptor(mockolate, _mockolatier);
		}
	}
}