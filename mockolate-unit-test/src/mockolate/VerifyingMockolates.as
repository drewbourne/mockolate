package mockolate
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import mockolate.errors.ExpectationError;
    import mockolate.errors.VerificationError;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    import mockolate.runner.MockolateRule;
    
    import org.flexunit.assertThat;
    import org.flexunit.asserts.fail;
    import org.flexunit.async.Async;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.nullValue;
    
    public class VerifyingMockolates
    {
    	[Rule]
    	public var mocks:MockolateRule = new MockolateRule();

    	[Mock(inject="false")]
    	public var flavour:Flavour;

    	[Mock(inject="false")]
    	public var darkChocolate:DarkChocolate;
	        
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
            try {
                var instance:Flavour = strict(Flavour);
            }
            catch (e:Error) {
                trace(e.getStackTrace());
                throw e;
            }
            
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
                assertThat(error.expectations, arrayWithSize(3));
            }
        }
        
        [Test]
        public function verifyingAsTestSpyAsPassing():void
        {
            var instance:Flavour = nice(Flavour);
            
            instance.combine(null);
            
            verify(instance).method("combine").args(nullValue()).once();
        }
    }
}