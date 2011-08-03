package mockolate
{
	import flash.utils.describeType;
	
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Example;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	public class UsingVectors
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var example:Example;
		
		[Test]
		public function shouldWorkAsExpected():void 
		{
			var expected:Vector.<Example> = new Vector.<Example>();
			describeType(expected);
			
			mocks.mock(example).method("returnsVector").returns(expected);

			assertThat(example.returnsVector(), equalTo(expected));
		}
	}
}