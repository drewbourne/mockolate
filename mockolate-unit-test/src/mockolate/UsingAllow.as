package mockolate
{
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.equalTo;

	public class UsingAllow
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var flavour:Flavour;
		
		[Mock]
		public var otherFlavour:Flavour;
		
		[Test]
		public function allowSyntaxForGetters_shouldBeSuccinct():void 
		{
			allow(flavour.name).returns("DarkChocolate");
			
			assertThat(flavour.name, equalTo("DarkChocolate"));
		}
		
		[Test]
		public function allowSyntaxForMethods_shouldBeSuccinct():void 
		{
			allow(flavour.toString()).returns("DarkChocolate");
			
			assertThat(flavour.toString(), equalTo("DarkChocolate"));
		}
		
		[Test]
		public function allowSyntaxForMethodsWithArgs_shouldBeSuccinct():void 
		{
			allow(flavour.combine(arg(otherFlavour))).returns(flavour);
			
			assertThat(flavour.combine(otherFlavour), equalTo(flavour));
			
			assertThat(flavour.combine(null), equalTo(null));
		}
		
		[Test]
		public function allow_shouldNotBeVerified():void 
		{
			allow(flavour.combine(arg(otherFlavour))).returns(flavour);
			
			verify(flavour);
		}
	}
}