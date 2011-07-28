package mockolate
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    
    import org.flexunit.async.Async;
    
    public class PreparingMockolates
    {
        // shorthands
        public function proceedWhen(target:IEventDispatcher, eventName:String, timeout:Number=5000, timeoutHandler:Function=null):void
        {
            Async.proceedOnEvent(this, target, eventName, timeout, timeoutHandler);
        }
        
        /*
           Preparing
         */
        
        [Test(async, timeout=5000)]
        public function prepareInterface():void
        {
            proceedWhen(
                prepare(Flavour),
                Event.COMPLETE);
        }
        
        [Test(async, timeout=5000)]
        public function prepareClass():void
        {
            proceedWhen(
                prepare(DarkChocolate),
                Event.COMPLETE);
        }
        
        [Test(async, timeout=5000)]
        public function prepareMixedAsDiscreteArguments():void
        {
            proceedWhen(
                prepare(Flavour, DarkChocolate),
                Event.COMPLETE);
        }
        
        [Test(async, timeout=5000)]
        public function prepareMixedAsArray():void
        {
            proceedWhen(
                prepare([ Flavour, DarkChocolate ]),
                Event.COMPLETE);
        }
    }
}