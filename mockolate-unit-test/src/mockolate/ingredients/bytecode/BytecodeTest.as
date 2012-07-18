package mockolate.ingredients.bytecode
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
//	import mx.core.FlexGlobals;
	
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.notNullValue;

	public class BytecodeTest
	{
		[Before]
		public function setup():void 
		{
//			ByteCodeType.fromLoader(FlexGlobals.topLevelApplication.loaderInfo);
		}

		private var _proxyFactory:IProxyFactory;
		private var _classInfo:IClassProxyInfo;
		private var _classProxy:Class;
		private var _async:IEventDispatcher;
		
		[Test(async, timeout=5000)]
		public function un_fucking_believable():void 
		{
			_async = new EventDispatcher();
			Async.proceedOnEvent(this, _async, Event.COMPLETE, 5000);
			
			_proxyFactory = new ProxyFactory();
			_proxyFactory.addEventListener(Event.COMPLETE, function():void {
				var instance:Ghostly = _proxyFactory.createProxy(Ghostly) as Ghostly;
				assertThat(instance, notNullValue());
				
				_async.dispatchEvent(new Event(Event.COMPLETE));
			});
			
			_classInfo = _proxyFactory.defineProxy(Ghostly);
			
			_proxyFactory.generateProxyClasses();
			_proxyFactory.loadProxyClasses();
		}
	}
}