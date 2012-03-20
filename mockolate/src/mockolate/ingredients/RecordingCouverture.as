package mockolate.ingredients
{
    use namespace mockolate_ingredient;
    
    /**
     * Couverture that records every Invocation passed to <code>invoked(Invocation)</code>.
     *
     * @author drewbourne
     */
    public class RecordingCouverture extends Couverture
    {
        [ArrayElementType("mockolate.ingredients.Invocation")]
        private var _invocations:Array;

        [ArrayElementType("mockolate.ingredients.Invocation")]
        private var _unexpectedInvocations:Array;
        
        /**
         * Constructor.
         */
        public function RecordingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
            
            _invocations = [];
            _unexpectedInvocations = [];
        }
        
        [ArrayElementType("mockolate.ingredients.Invocation")]
        /**
         * Returns the recorded Invocations up to the time this property is accessed.
         */
        mockolate_ingredient function get invocations():Array
        {
            return _invocations.slice(0);
        }

        [ArrayElementType("mockolate.ingredients.Invocation")]
        /**
         * Returns the unexpected Invocations up to the time this property is accessed.
         */
        mockolate_ingredient function get unexpectedInvocations():Array
        {
            return _unexpectedInvocations.slice(0);
        }
        
        /**
         * Records the given Invocation.
         */
        override mockolate_ingredient function invoked(invocation:Invocation):Boolean
        {
            addInvocation(invocation);
			
			// recording always continues to the other Couvertures
			return false;
        }
        
        /**
         * Adds an Invocation to the <code>invocations</code> Array.
         */
        mockolate_ingredient function addInvocation(invocation:Invocation):void
        {
            _invocations.push(invocation);
        }
		
        /**
         * Removes an Invocation to the <code>invocations</code> Array.
         */
		mockolate_ingredient function removeInvocation(invocation:Invocation):void 
		{
			var index:int = _invocations.indexOf(invocation);
			if (index != -1)
			{
				_invocations.splice(index, 1);
			}
		}

        /**
         * Adds an Invocation to the <code>unexpectedInvocations</code> Array.
         */
        mockolate_ingredient function addUnexpectedInvocation(invocation:Invocation):void
        {
            _unexpectedInvocations.push(invocation);
        }
        
        /**
         * Removes an Invocation to the <code>unexpectedInvocations</code> Array.
         */
        mockolate_ingredient function removeUnexpectedInvocation(invocation:Invocation):void 
        {
            var index:int = _unexpectedInvocations.indexOf(invocation);
            if (index != -1)
            {
                _unexpectedInvocations.splice(index, 1);
            }
        }
        
        /**
         * @private
         */
        override mockolate_ingredient function verify():void
        {
        
        }
    }
}
