package mockolate.ingredients.proxy
{
	import flash.events.EventDispatcher;
	
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.ingredients.proxy.MockolateProxy;
	import mockolate.sample.Example;
	
	use namespace mockolate_ingredient;
	
	public class ExampleMock extends EventDispatcher implements Example {
		
		private var proxy:MockolateProxy;
		
		public function ExampleMock()
		{
			proxy = new MockolateProxy(this);
		}
		
		public function acceptNumber( value:Number ):void
		{
			proxy.acceptNumber(value);	
		}
		
		public function giveString():String
		{
			return proxy.giveString();	
		}
		
		public function optional( ...rest ):void
		{
			proxy.invokeMethod("optional", rest);
		}
		
		public function justCall():void
		{
			proxy.justCall();
		}
		
		public function dispatchMyEvent():void
		{
			proxy.dispatchMyEvent();
		}
		
		public function callWithRest(...rest):void
		{
			proxy.invokeMethod("callWithRest", rest);
		}
	}
	

}