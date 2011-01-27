package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
	
	/**
	 * Calls the super method or property.
	 * 
	 * @see mockolate.ingredients.MockingCouverture#callsSuper()
	 * 
     * @example
     * <listing version="3.0">
     *  mock(instance).method("example").callsSuper();
     * </listing>
     */
    public class CallsSuperAnswer implements Answer
	{
		/**
		 * Constructor.
		 */
		public function CallsSuperAnswer()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function invoke(invocation:Invocation):*
		{
			invocation.proceed();
			return invocation.returnValue;
		}
	}
}
