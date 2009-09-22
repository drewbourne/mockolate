package mockolate
{
    import asx.object.isA;
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    
    import mockolate.ingredients.Mockolate;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.object.strictlyEqualTo;
    
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
        public function verifying():void
        {
            var instance:Flavour = nice(Flavour);
            
            stub(instance, "combine").args(nullValue());
            
            instance.combine(null);
            
            verify(instance);
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
        public function verifyingAsTestSpy():void
        {
            var instance:Flavour = nice(Flavour);
            
            instance.combine(null);
            
            verify(instance, "combine").args(nullValue()).once();
        }
    
    }
}