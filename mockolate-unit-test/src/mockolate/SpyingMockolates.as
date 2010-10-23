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
		
		[Test]
		public function receivedMethodsShouldPassIfAtLeastOneMatchingInvocation():void 
		{
			flavour.combine(otherFlavour);
			
			assertThat(flavour, received().methods(/^com/).args(otherFlavour));
		}
		
		[Test]
		public function receivedMethodsShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().methods(/^com/).args(Flavour));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour)./^com/(<[class Flavour]>) invoked 0/1 (-1) times"));
			}			
		}
			
		[Test]
		public function receivedGetterShouldPassIfAtLeastOneMatchingInvocation():void 
		{
			flavour.name;
			
			assertThat(flavour, received().getter("name"));
		}
		
		[Test]
		public function receivedGetterShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().getter("name"));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour).name; invoked 0/1 (-1) times"));
			}			
		}
		
		[Test]
		public function receivedGettersShouldPassIfAtLeastOneMatchingInvocation():void 
		{
			flavour.name;
			
			assertThat(flavour, received().getters(/me$/));
		}
		
		[Test]
		public function receivedGettersShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().getters(/me$/));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour)./me$/; invoked 0/1 (-1) times"));
			}	
		}
		
		[Test]
		public function receivedSetterShouldPassIfAtLeastOneMatchingInvocation():void 
		{
			flavour.liked = true;
			
			assertThat(flavour, received().setter("liked").arg(true));			
		}
		
		[Test]
		public function receivedSetterShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().setter("liked").arg(true));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour).liked = <true>; invoked 0/1 (-1) times"));
			}
		}
		
		[Test]
		public function receivedSettersShouldPassIfAtLeatOneMatchingInvocation():void 
		{
			flavour.liked = true;
			
			assertThat(flavour, received().setters(/ike/).arg(true));
		}
		
		[Test]
		public function receivedSettersShouldFailIfNoMatchingInvocations():void 
		{
			try 
			{
				assertThat(flavour, received().setters(/ike/).arg(true));
				fail("Expecting AssertionError");
			}
			catch (error:AssertionError)
			{
				assertThat(error.mismatchDescription, equalTo("Flavour(flavour)./ike/ = <true>; invoked 0/1 (-1) times"));
			}
		}
	}
}