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
    
    public class PreparingMockolates
    {
        // shorthands
        public function proceedWhen(target:IEventDispatcher, eventName:String, timeout:Number=3000, timeoutHandler:Function=null):void
        {
            Async.proceedOnEvent(this, target, eventName, timeout, timeoutHandler);
        }
        
        /*
           Preparing
         */
        
        [Test(async, timeout=3000)]
        public function prepareInterface():void
        {
            proceedWhen(
                prepare(Flavour),
                Event.COMPLETE);
        }
        
        [Test(async, timeout=3000)]
        public function prepareClass():void
        {
            proceedWhen(
                prepare(DarkChocolate),
                Event.COMPLETE);
        }
        
        [Test(async, timeout=3000)]
        public function prepareMixedAsDiscreteArguments():void
        {
            proceedWhen(
                prepare(Flavour, DarkChocolate),
                Event.COMPLETE);
        }
        
        [Test(async, timeout=3000)]
        public function prepareMixedAsArray():void
        {
            proceedWhen(
                prepare([ Flavour, DarkChocolate ]),
                Event.COMPLETE);
        }
    }
}