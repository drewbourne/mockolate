package mockolate.ingredients.bytecode
{
	import flash.display.Sprite;
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
		
//		[Mock(type="nice")]
//		public var concrete:Concrete;
//		
//		[Mock(type="nice")]
//		public var ghostly:Ghostly;
		
		[Mock]
		public var natively:Sprite;
		
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
//		
//		[Test]
//		public function interfaces():void 
//		{
//			assertThat(ghostly, notNullValue());
//			assertThat(ghostly.toString(), equalTo('[GhostlyProxy]'));
//		}
		
		[Test]
		public function nativeClasses():void 
		{
			assertThat(natively, notNullValue());
		}
	}
}