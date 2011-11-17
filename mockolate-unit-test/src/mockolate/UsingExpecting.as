package mockolate
{
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class UsingExpecting
	{
		// Instances created as "strict" Mock Objects must have their 
		// expectations defined within an `expecting()` function in order
		// to correctly identify expectation invocations vs usage invocations. 
		// 
		
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var flavour:Flavour;
		
		[Mock]
		public var otherFlavour:Flavour;
		
		[Test]
		public function using_expect_should_allow_expectations_to_be_defined_on_strict_mocks():void 
		{
			expecting(function():void {
				expect(flavour.combine(otherFlavour)).returns(flavour);
			});
			
			assertThat(flavour.combine(otherFlavour), equalTo(flavour)); 
		}
	}
}