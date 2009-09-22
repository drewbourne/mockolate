package mockolate.ingredients.answers
{
    
    /**
     * @example
     * <listing version="3.0">
     *  stub.calls(function():void {
     *      // arbitrary action
     *  });
     * </listing>
     */
    public class CallsAnswer implements Answer
    {
        private var _function:Function;
        private var _args:Array;
        
        public function CallsAnswer(fn:Function, args:Array=null)
        {
            _function = fn;
            _args = args;
        }
        
        public function invoke():*
        {
            _function.apply(null, _args);
            return undefined;
        }
    }
}
