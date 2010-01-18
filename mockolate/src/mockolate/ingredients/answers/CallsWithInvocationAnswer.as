package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
    
    /**
     * Calls a Function with the Invocation as the first argument.
     * 
     * @see mockolate.ingredients.MockingCouverture
     * @see mockolate.ingredients.MockingCouverture#answers()
     * 
     * @example
     * <listing version="3.0">
     *  mock(instance).method("message").answers(new CallsWithInvocation(function(invocation:Invocation, a:int, b:int):void {
     * 		trace(invocation.name, a, b);
     * 		// "message  1 2"
     * 	}, [1, 2]));
     * </listing>
     */
    public class CallsWithInvocationAnswer implements Answer
    {
        private var _function:Function;
        private var _args:Array;
        
        /**
         * Constructor.
         * 
         * @param fn Function to call
         * @param args Array of arguments to pass to fn. 
         */
        public function CallsWithInvocationAnswer(fn:Function, args:Array=null)
        {
            _function = fn;
            _args = args || [];
        }
        
        /**
         * @inheritDoc 
         */
        public function invoke(invocation:Invocation):*
        {
            _function.apply(null, [invocation].concat(_args).slice(0, _function.length));
            return undefined;
        }
    }
}
