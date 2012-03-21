package mockolate
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import mockolate.errors.ExpectationError;
    import mockolate.errors.VerificationError;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    
    import org.flexunit.assertThat;
    import org.flexunit.asserts.fail;
    import org.flexunit.async.Async;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.nullValue;
    
    public class VerifyingMockolates
    {
        // shorthands
        public function proceedWhen(target:IEventDispatcher, eventName:String, timeout:Number=30000, timeoutHandler:Function=null):void
        {
            Async.proceedOnEvent(this, target, eventName, timeout, timeoutHandler);
        }
        
        [Before(async, timeout=30000)]
        public function prepareMockolates():void
        {
            proceedWhen(
                prepare(Flavour, DarkChocolate),
                Event.COMPLETE);
        }
        
        /*
           Verifying
         */
        
        [Test]
        public function verifyingMockBehaviourAsPassing():void
        {
            var instance:Flavour = strict(Flavour);
            
            mock(instance).method("combine").args(nullValue());
            
            instance.combine(null);
            
            verify(instance);
        }
        
        [Test(expected="mockolate.errors.ExpectationError")]
        public function verifyingMockBehaviourAsFailingAsNotCalled():void
        {
            var instance:Flavour = strict(Flavour);
            
            mock(instance).method("combine").args(nullValue());
            
            verify(instance);
        }
        
        [Test]
        public function verifyingShouldReturnAllUnmetExpectations():void 
        {
            var instance:Flavour = strict(Flavour);
            
            mock(instance).getter("name").returns("blueberry");
            mock(instance).getter("ingredients").returns([]);
            mock(instance).method("toString").returns("blueberry");
            
            try 
            {
                verify(instance); 
            }
            catch (error:ExpectationError)
            {
//                trace(error.message);
                assertThat(error.expectations, arrayWithSize(3));
            }
        }
        
        /*
           Verifying nice mock as Test Spy
        
           // verify api
           // verify: test spy
           verify(instance:*, propertyOrMethod:String, ...matchers):Verifier
           // verify: argument matchers
           .args(...matchers)
           // verify: receive count
           .times(n:int)
           .never()
           .once()
           .twice()
           .thrice()
           .atLeast(n:int)
           .atMost(n:int)
           // verify: expectation ordering
           .ordered(group:String="global")
         */
        
        [Test]
        public function verifyingAsTestSpyAsPassing():void
        {
            var instance:Flavour = nice(Flavour);
            
            instance.combine(null);
            
            verify(instance).method("combine").args(nullValue()).once();
        }
        
		[Test]
        public function verifyingAsTestSpyAsFailing():void
        {
            var instance:Flavour = nice(Flavour);
            
			try 
			{
            	verify(instance).method("combine").noArgs();
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("Expected: at least <1> invocations of combine()\n\t\tbut: mockolate.sample::Flavour.combine() invoked 0/1 (-1) times"));
			}
        }
		
		[Ignore("verify() requires args(), noArgs()")]
		[Test]
		public function verifyingAsTestSpyAsFailingInvocationTypeMethod():void
		{
			var instance:Flavour = nice(Flavour);
			
			try 
			{
				verify(instance).method("combine");
				fail("VerificationError not thrown");
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("Flavour.combine() invoked 0 times"));
			}
		}
		
		[Test]
		public function verifyingAsTestSpyAsFailingInvocationTypeMethodWithArguments():void
		{
			var instance:Flavour = nice(Flavour);
			var other1:Flavour = nice(Flavour);
			var other2:Flavour = nice(Flavour);
			
			instance.combine(other1, other2);
			
			try 
			{
				verify(instance).method("combine").args(Flavour);
				fail("VerificationError not thrown");
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("Expected: at least <1> invocations of combine(<[class Flavour]>)\n\t\tbut: mockolate.sample::Flavour.combine(<[class Flavour]>) invoked 0/1 (-1) times"));
			}
		}
		
		[Test]
		public function verifyingAsTestSpyAsFailingInvocationTypeMethodWithArgumentsAndInvokeCount():void
		{
			var instance:Flavour = nice(Flavour);
			var other:Flavour = nice(Flavour);
			
			instance.combine(other);
			
			try 
			{
				verify(instance).method("combine").args(Flavour).atLeast(2);
				fail("VerificationError not thrown");
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("Expected: at least <2> invocations of combine(<[class Flavour]>)\n\t\tbut: mockolate.sample::Flavour.combine(<[class Flavour]>) invoked 1/2 (-1) times"));
			}
		}
		
		[Ignore("never() cannot be supported using the verify() syntax")]
		[Test]
		public function verifyingAsTestSpyAsPassingInvocationTypeMethodWithArgumentsAndInvokeCountAsNever():void
		{
			var instance:Flavour = nice(Flavour);
			
			verify(instance).method("combine").args(Flavour).never();
		}
		
		[Ignore("never() cannot be supported using the verify() syntax")]
		[Test]
		public function verifyingAsTestSpyAsFailingInvocationTypeMethodWithArgumentsAndInvokeCountAsNever():void
		{
			var instance:Flavour = nice(Flavour);
			var other:Flavour = nice(Flavour);
			
			instance.combine(other);
			instance.combine(other);
			instance.combine(other);
			
			try 
			{
				verify(instance).method("combine").args(Flavour).never();
				fail("VerificationError not thrown");
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("mockolate.sample::Flavour.combine([class Flavour]) invoked 3 times"));
			}
		}
		
		[Test]
		public function verifyingAsTestSpyAsFailingInvocationTypeGetter():void
		{
			var instance:Flavour = nice(Flavour);
			
			try
			{
				verify(instance).getter('name');
				fail("VerificationError not thrown");
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("Expected: at least <1> invocations of name;\n\t\tbut: mockolate.sample::Flavour.name; invoked 0/1 (-1) times"));
			}
		}
		
		[Test]
		public function verifyingAsTestSpyAsFailingInvocationTypeSetter():void
		{
			var instance:Flavour = nice(Flavour);
			
			try
			{
				verify(instance).setter('liked'); //.arg(true);
				fail("VerificationError not thrown");
			}
			catch (error:VerificationError)
			{
				assertThat(error.message, equalTo("Expected: at least <1> invocations of liked = ?;\n\t\tbut: mockolate.sample::Flavour.liked = ?; invoked 0/1 (-1) times"));
			}
		}
        
        [Test(expected="mockolate.errors.VerificationError")]
        public function verifyingAsTestSpyAsFailingInvokedCount():void
        {
            var instance:Flavour = nice(Flavour);
            
            instance.combine(null);
            
            verify(instance)
                .method("combine")
                .args(nullValue())
                .twice();
        }
		
		[Test(expected="mockolate.errors.VerificationError")]
		public function verifyAsTestSpyFailingInvokedCountNever():void 
		{
			var instance:Flavour = nice(Flavour);
			
			instance.combine(null);
			
			verify(instance).method("combine").args(nullValue()).times(0);
		}
    }
}