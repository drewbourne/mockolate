package mockolate.ingredients.answers
{
    
    /**
     * @example
     * <listing version="3.0">
     *  stub.returns(Function)
     * </listing>
     */
    public class ReturnsCallAnswer implements Answer
    {
        private var _function:Function;
        private var _args:Array;
        
        public function ReturnsCallAnswer(fn:Function, args:Array=null)
        {
            _function = fn;
            _args = args;
        }
        
        public function invoke():*
        {
            return _function.apply(null, _args);
        }
    }
}
