package mockolate
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    
    import mockolate.ingredients.Mockolate;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    import mockolate.runner.MockolateRule;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.object.strictlyEqualTo;
    
    public class UsingNiceMockolates
    {
        [Rule]
        public var mocks:MockolateRule = new MockolateRule();

        [Mock(inject="false")]
        public var flavour:Flavour;

        [Mock(inject="false")]
        public var darkChocolate:DarkChocolate;
        
        /*
           Nice Mocks
         */
        
        [Test]
        public function niceMockFromInterface():void
        {
            var instance:Flavour = nice(Flavour);
            
            assertThat(instance, instanceOf(Flavour));
            assertThat(instance, not(instanceOf(DarkChocolate)));
        }
        
        [Test]
        public function niceMockFromClass():void
        {
            var instance:Flavour = nice(DarkChocolate);
            
            assertThat(instance, instanceOf(Flavour));
            assertThat(instance, instanceOf(DarkChocolate));
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