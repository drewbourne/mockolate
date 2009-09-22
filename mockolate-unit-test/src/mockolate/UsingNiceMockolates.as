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
    
    public class UsingNiceMockolates
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
           Nice Mocks
         */
        
        [Test]
        public function niceMockFromInterface():void
        {
            var instance:Flavour = nice(Flavour);
            
            assertThat(instance, isA(Flavour));
            assertThat(instance, not(isA(DarkChocolate)));
        }
        
        [Test]
        public function niceMockFromClass():void
        {
            var instance:Flavour = nice(DarkChocolate);
            
            assertThat(instance, isA(Flavour));
            assertThat(instance, isA(DarkChocolate));
        }
        
        [Test]
        public function niceMocksAcceptAndIgnoreUnexpectedPropertyCalls():void
        {
            var instance:Flavour = nice(Flavour);
            instance.ingredients = [];
        }
        
        [Test]
        public function niceMocksReturnFalseyValuesForUnexpectedPropertyCalls():void
        {
            var instance:Flavour = nice(Flavour);
            var result:* = instance.name;
            assertThat(result, nullValue());
        }
        
        [Test]
        public function niceMocksReturnFalseyValuesForUnexpectedMethodCalls():void
        {
            var instance:Flavour = nice(Flavour);
            var result:* = instance.combine(null);
            assertThat(result, nullValue());
        }
        
        [Test]
        public function niceMocksIgnoreUnexpectedMethodCalls():void
        {
            var instance:Flavour = nice(Flavour);
            instance.combine(null);
            instance.toString();
        }
    
    }
}