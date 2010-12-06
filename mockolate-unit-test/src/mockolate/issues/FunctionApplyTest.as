package mockolate.issues
{
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class FunctionApplyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var flavour:Flavour;
		
		[Mock]
		public var other1:Flavour;
		
		[Mock]
		public var other2:Flavour;
		
		[Test]
		public function functionApplyShouldAllowMocking():void 
		{
			mock(flavour).method("combine").args(other1).returns(other2);
			
			var result:Flavour = flavour.combine.apply(flavour, [other1]);
			assertThat(result, equalTo(result));
		}
		
		[Test]
		public function functionCallShouldAllowMocking():void 
		{
			mock(flavour).method("combine").args(other1).returns(other2);
			
			var result:Flavour = flavour.combine.call(flavour, other1);
			assertThat(result, equalTo(result));			
		}
		
		[Test]
		public function functionApplyShouldRecordInvocation():void 
		{
			flavour.combine.apply(flavour, [other1, other2]);
			
			assertThat(flavour, received().method('combine').args(other1, other2));
		}
		
		[Test]
		public function functionCallShouldRecordInvocation():void 
		{
			flavour.combine.call(flavour, other1, other2);
			
			assertThat(flavour, received().method('combine').args(other1, other2));
		}
	}
}