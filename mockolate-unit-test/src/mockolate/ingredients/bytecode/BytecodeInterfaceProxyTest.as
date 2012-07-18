package mockolate.ingredients.bytecode
{
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;

	public class BytecodeInterfaceProxyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var ghostly:Ghostly;
		
		[Test]
		public function interfaces():void 
		{
			mocks.stub(ghostly).method('toString').returns('[GhostlyProxy]');
			
			assertThat(ghostly, notNullValue());
			assertThat(ghostly.toString(), equalTo('[GhostlyProxy]'));
		}
	}
}