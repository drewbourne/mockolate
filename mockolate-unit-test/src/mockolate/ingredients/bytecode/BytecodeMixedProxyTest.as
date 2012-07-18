package mockolate.ingredients.bytecode
{
	import flash.display.Sprite;
	
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;

	public class BytecodeMixedProxyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var concrete1:Concrete;
		
		[Mock]
		public var concrete2:Concrete;
		
		[Mock]
		public var ghostly1:Ghostly;
		
		[Mock]
		public var ghostly2:Ghostly;
		
		[Test]
		public function instances():void 
		{
			assertThat(concrete1, notNullValue());
			assertThat(concrete2, notNullValue());
			assertThat(ghostly1, notNullValue());
			assertThat(ghostly2, notNullValue());
		}
	}
}