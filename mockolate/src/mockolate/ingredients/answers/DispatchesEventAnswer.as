package mockolate.ingredients.answers
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.setTimeout;
    
    /**
     * @example
     * <listing version="3.0">
     *  stub.dispatches(new Event("now"));
     *  stub.dispatches(new Event("eventually"), 100);
     * </listing>
     */
    public class DispatchesEventAnswer implements Answer
    {
        private var _dispatcher:IEventDispatcher;
        private var _event:Event;
        private var _delay:Number;
        private var _timeout:uint;
        
        public function DispatchesEventAnswer(dispatcher:IEventDispatcher, event:Event, delay:Number=0)
        {
            _dispatcher = dispatcher;
            _event = event;
            _delay = delay;
        }
        
        public function invoke():*
        {
            if (_delay == 0)
            {
                dispatchEvent();
            }
            else
            {
                _timeout = setTimeout(dispatchEvent, _delay);
            }
            return undefined;
        }
        
        protected function dispatchEvent():void
        {
            _dispatcher.dispatchEvent(_event);
        }
    }
}
