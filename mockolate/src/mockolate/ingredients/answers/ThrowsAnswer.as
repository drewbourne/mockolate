package mockolate.ingredients.answers
{
    
    /**
     * @example
     * <listing version="3.0">
     *  stub.throws(new ArgumentError("Oh no!"));
     * </listing>
     */
    public class ThrowsAnswer implements Answer
    {
        private var _error:Error;
        
        public function ThrowsAnswer(error:Error)
        {
            _error = error;
        }
        
        public function invoke():*
        {
            throw _error;
        }
    }
}
