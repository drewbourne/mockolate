package mockolate
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    
    import mockolate.ingredients.Mockolate;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    import mockolate.runner.MockolateRule;
    
    import org.flexunit.async.Async;
    import org.hamcrest.assertThat;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.object.strictlyEqualTo;
    
    public class UsingStrictMockolates
    {
        [Rule]
        public var mocks:MockolateRule = new MockolateRule();

        [Mock(inject="false")]
        public var flavour:Flavour;

        [Mock(inject="false")]
        public var darkChocolate:DarkChocolate;

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
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function strictMockComplainOnUnexpectedPropertySet():void
        {
            var instance:Flavour = strict(Flavour);
            instance.ingredients = [];
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function strictMockComplainOnUnexpectedPropertyGet():void
        {
            var instance:Flavour = strict(Flavour);
            var result:* = instance.ingredients;
        }
        
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function strictMocksComplainOnUnexpectedMethodCalls():void
        {
            var instance:Flavour = strict(Flavour);
            var result:* = instance.combine(null);
        }
    
    }
}