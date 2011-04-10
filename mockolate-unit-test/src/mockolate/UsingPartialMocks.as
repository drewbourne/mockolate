package mockolate
{
	import flash.events.IEventDispatcher;
	
	import mockolate.runner.MockolateRule;
	import mockolate.sample.DarkChocolate;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class UsingPartialMocks
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(type="partial")]
		public var flavour:DarkChocolate;
		
		[Test]
		public function shouldCallSuperIfNoExpectationDefined():void 
		{
			assertThat(flavour.name, equalTo("Dark Chocolate"));
		}
		
		[Test]
		public function shouldCallExpectationWhenDefined():void 
		{
			stub(flavour).getter("name").returns("Dark Mockolate");
			
			assertThat(flavour.name, equalTo("Dark Mockolate"));
		}
		
		[Test]
		public function invocationsShouldBeRecordedIfNoExpectationDefined():void
		{
			flavour.ingredients;
			
			assertThat(flavour, received().getter("ingredients").once());
		}
		
		[Test]
		public function invocationsShouldBeRecordedWhenExpectationDefined():void
		{
			stub(flavour).getter("ingredients").returns(["vanilla", "butter", "milk"]);
			
			flavour.ingredients;
			
			assertThat(flavour, received().getter("ingredients").once());
		}
		
		[Test]
		public function partialFunction_shouldCreatePartialMockObject():void 
		{
		    flavour = partial(DarkChocolate);
		    
		    //exercise partial
		    assertThat(flavour.name, equalTo("Dark Chocolate"));
		    
		    stub(flavour).getter("name").returns("Dark Mockolate");
			assertThat(flavour.name, equalTo("Dark Mockolate"));
		}
		
		[Test]
		public function partialRuleFunction_shouldCreatePartialMockObject():void 
		{
		    flavour = mocks.partial(DarkChocolate);
		    
		    //exercise partial
		    assertThat(flavour.name, equalTo("Dark Chocolate"));
		    
		    stub(flavour).getter("name").returns("Dark Mockolate");
			assertThat(flavour.name, equalTo("Dark Mockolate"));
		}
	}
}