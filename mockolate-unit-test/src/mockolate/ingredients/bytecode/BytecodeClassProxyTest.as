package mockolate.ingredients.bytecode
{
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;

	public class BytecodeClassProxyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var concrete:Concrete;
		
		[Test]
		public function classes():void 
		{
			mocks.expect(concrete.isSolid).returns(true);
			mocks.stub(concrete).method('toString').returns('[ConcreteProxy]');
			
			// TODO determine why this fails. 
//			mocks.expect(concrete.toString()).returns('[ConcreteProxy]');
			
			assertThat(concrete, notNullValue());
			assertThat(concrete.isSolid, isTrue());
			assertThat(concrete.toString(), equalTo('[ConcreteProxy]'));
		}
	}
}