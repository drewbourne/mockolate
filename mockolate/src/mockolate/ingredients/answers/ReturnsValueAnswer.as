package mockolate.ingredients.answers
{
    
    /**
     * @example
     * <listing version="3.0">
     *  stub.returns(1)
     * </listing>
     */
    public class ReturnsValueAnswer implements Answer
    {
        private var _value:*;
        
        public function ReturnsValueAnswer(value:*)
        {
            _value = value;
        }
        
        public function invoke():*
        {
            return _value;
        }
    }
}