package mockolate.ingredients.bytecode
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;

	public class BytecodeNativeProxyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var natively:Sprite;
		
		[Test]
		public function nativeClasses():void 
		{
			assertThat(natively, notNullValue());
		}
	}
}