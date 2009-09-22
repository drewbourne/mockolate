package mockolate
{
    import asx.object.isA;
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    
    import mockolate.errors.StubMissingError;
    import mockolate.ingredients.Mockolate;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    
    import org.flexunit.async.Async;
    import org.hamcrest.assertThat;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.object.strictlyEqualTo;
    
    public class UsingStrictMockolates
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
           Strict Mocks
         */
        
        [Test]
        public function strictMocksFromInterface():void
        {
            var instance:Flavour = strict(Flavour);
            
            assertThat(instance, instanceOf(Flavour));
            assertThat(instance, not(instanceOf(DarkChocolate)));
        }
        
        [Test]
        public function strictMocksFromClass():void
        {
            var instance:Flavour = strict(DarkChocolate);
            
            assertThat(instance, instanceOf(Flavour));
            assertThat(instance, instanceOf(DarkChocolate));
        }
        
        [Test(expected="mockolate.errors.StubMissingError")]
        public function strictMockComplainOnUnexpectedPropertySet():void
        {
            var instance:Flavour = strict(Flavour);
            instance.ingredients = [];
        }
        
        [Test(expected="mockolate.errors.StubMissingError")]
        public function strictMockComplainOnUnexpectedPropertyGet():void
        {
            var instance:Flavour = strict(Flavour);
            var result:* = instance.ingredients;
        }
        
        
        [Test(expected="mockolate.errors.StubMissingError")]
        public function strictMocksComplainOnUnexpectedMethodCalls():void
        {
            var instance:Flavour = strict(Flavour);
            var result:* = instance.combine(null);
        }
    
    }
}