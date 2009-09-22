package mockolate.ingredients.answers
{
    import asx.number.bound;
    
    
    /**
     * @example
     * <listing version="3.0">
     *  stub.returns(1)
     *  stub.returns(1, 2, 3)
     *  stub.returns(1, 2, Function)
     * </listing>
     */
    public class ReturnsAnswer implements Answer
    {
        private var _values:Array;
        private var _index:int;
        
        public function ReturnsAnswer(values:Array)
        {
            _values = values || [];
            _index = -1;
        }
        
        public function invoke():*
        {
            _index++;
            _index = bound(_index, 0, _values.length - 1);
            
            var value:* = _values[_index];
            return (value is Answer) ? (value as Answer).invoke() : value;
        }
    }
}