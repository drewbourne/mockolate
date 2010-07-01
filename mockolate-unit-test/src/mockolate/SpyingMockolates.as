package mockolate
{
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.fail;
	import org.hamcrest.AssertionError;
	import org.hamcrest.object.equalTo;

	public class SpyingMockolates
	{
		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		
		[Mock]
		public var flavour:Flavour;
		
		[Mock]
		public var otherFlavour:Flavour;
		
		[Test]
		public function receivedMethodShouldPassIfAtLeastOneMatchingInvocation():void 
		{
			flavour.combine(otherFlavour);
			
			assertThat(flavour, received().method('combine'));
		}
		
		[Test]
		public function receivedMethodShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().method('combine'));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour).combine() invoked 0/1 (-1) times"));
			}
		}
		
		[Test]
		public function receivedMethodWithArgumentsShouldPassIfAtLeastOneMatchingInvocation():void 
		{
			flavour.combine(otherFlavour);
			
			assertThat(flavour, received().method('combine').args(otherFlavour));
		}
		
		[Test]
		public function recievedMethodWithArgumentsShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().method('combine').args(Flavour));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour).combine(<[class Flavour]>) invoked 0/1 (-1) times"));
			}
		}
		
		[Test]
		public function receivedMethodWithArgumentsAndInvokedCountShouldPassIfMatchingNumberOfInvocations():void 
		{
			flavour.combine(otherFlavour);
			
			assertThat(flavour, received().method('combine').args(otherFlavour));
		}
		
		[Test]
		public function recievedMethodWithArgumentsAndInvokedCountShouldFailIfNoMatchingInvocations():void 
		{
			flavour.combine(otherFlavour);
			
			try 
			{
				assertThat(flavour, received().method('combine').args(Flavour).twice());
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour).combine(<[class Flavour]>) invoked 1/2 (-1) times"));
			}
		}
	}
}