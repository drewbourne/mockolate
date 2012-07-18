package mockolate.ingredients.bytecode
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;

	public class BytecodeProxyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
//		[Mock]
//		public var concrete:Concrete;
		
		[Mock]
		public var ghostly:Ghostly;
		
//		[Mock]
//		public var natively:Sprite;
		
//		[Test]
//		public function classes():void 
//		{
//			mocks.stub(concrete).method('toString').returns('[ConcreteProxy]');
//			mocks.stub(ghostly).method('toString').returns('[GhostlyProxy]');
//			
//			assertThat(concrete, notNullValue());
//			assertThat(concrete.toString(), equalTo('[ConcreteProxy]'));
//			assertThat(concrete.isSolid, isFalse());
//		}

		[Mock]
		public var eventDispatcher:EventDispatcher;

		[Test]
		public function eventDispatcher_should_exist():void 
		{
			assertThat(eventDispatcher, notNullValue());
		}

		[Mock]
		public var ieventDispatcher:IEventDispatcher;

		[Test]
		public function ieventDispatcher_should_exist():void 
		{
			assertThat(ieventDispatcher, notNullValue());
		}
		
		[Test]
		public function interfaces():void 
		{
			assertThat(ghostly, notNullValue());
			// assertThat(ghostly.toString(), equalTo('[GhostlyProxy]'));
		}
		
//		[Test]
//		public function nativeClasses():void 
//		{
//			assertThat(natively, notNullValue());
//		}
	}
}