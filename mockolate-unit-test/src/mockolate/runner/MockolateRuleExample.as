package mockolate.runner
{
	import mockolate.mock;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;

	public class MockolateRuleExample
	{
		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		
		[Mock]
		public var flavour:Flavour;		
		
		[Test]
		public function ruleShouldReceiveTestInstance():void 
		{
			assertThat(flavour, notNullValue());
		}
		
		[Test]
		public function ruleShouldApplyThenEvaluateForEachTest():void 
		{
			assertThat(flavour, notNullValue());
		}
		
		[Ignore]
		[Test]
		public function failVerify():void 
		{
			mock(flavour).method("combine").args(Flavour).once();
		}
	}
}