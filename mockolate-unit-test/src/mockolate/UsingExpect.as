package mockolate
{
	import mockolate.errors.ExpectationError;
	import mockolate.errors.InvocationError;
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.core.anything;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;

	public class UsingExpect
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var flavour:Flavour;
		
		[Mock]
		public var otherFlavour:Flavour;
		
		[Mock(type="strict")]
		public var strictFlavour:Flavour;
		
		[Test]
		public function expectSyntaxForGetters_shouldBeSuccinct():void 
		{
			expect(flavour.name).returns("DarkChocolate");
			
			assertThat(flavour.name, equalTo("DarkChocolate"));
		}
		
		[Test]
		public function expectSyntaxForMethods_shouldBeSuccinct():void 
		{
			expect(flavour.toString()).returns("DarkChocolate");
			
			assertThat(flavour.toString(), equalTo("DarkChocolate"));
		}
		
		[Test]
		public function expectSyntaxForMethodsWithArgs_shouldBeSuccinct():void 
		{
			expect(flavour.combine(arg(otherFlavour))).returns(flavour);
			
			assertThat(flavour.combine(otherFlavour), equalTo(flavour));
			
			assertThat(flavour.combine(null), equalTo(null));
		}
		
		[Test(verify="false")]
		public function expect_with_strict_mocks_without_expecting_should_explode():void 
		{
			assertThat(function():void {
				expect(strictFlavour.combine(otherFlavour));
			}, throws(InvocationError));	
		}
		
		[Test(verify="false")]
		public function expect_with_strict_mocks_inside_expecting_should_define_expectations():void 
		{
			expecting(function():void {
				expect(strictFlavour.combine(otherFlavour)).returns(strictFlavour);
			});
			
			assertThat(strictFlavour.combine(otherFlavour), equalTo(strictFlavour)); 
		}
		
		[Test(verify="false")]
		public function expect_shouldBeVerified():void 
		{
			expect(flavour.combine(arg(otherFlavour))).returns(flavour);
			
			assertThat(function():void {
				verify(flavour);
			}, throws(ExpectationError));
		}
	}
}