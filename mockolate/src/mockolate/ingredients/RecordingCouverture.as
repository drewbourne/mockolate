package mockolate.ingredients
{
    use namespace mockolate_ingredient;
    
    /**
     * Couverture that records every IInvocation passed to <code>invoked(IInvocation)</code>.
     *
     * @author drewbourne
     */
    public class RecordingCouverture extends Couverture
    {
        [ArrayElementType("mockolate.ingredients.Invocation")]
        private var _invocations:Array;
        
        /**
         * Constructor.
         */
        public function RecordingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
            
            _invocations = [];
        }
        
        /**
         * Returns the recorded IInvocations up to the time this property is accessed.
         */
        [ArrayElementType("mockolate.ingredients.Invocation")]
        mockolate_ingredient function get invocations():Array
        {
            return _invocations.slice(0);
        }
        
        /**
         * Records
         */
        override mockolate_ingredient function invoked(invocation:Invocation):void
        {
            addInvocation(invocation);
        }
        
        /**
         * Adds an IInvocation to the <code>invocations</code> Array.
         */
        protected function addInvocation(invocation:Invocation):void
        {
            _invocations.push(invocation);
        }
        
        /**
         *
         */
        override mockolate_ingredient function verify():void
        {
        
        }
    }
}
