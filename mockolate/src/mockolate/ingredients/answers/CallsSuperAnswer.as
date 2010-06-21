package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
	
	/**
     * @example
     * <listing version="3.0">
     *  stub.callsSuper();
     * </listing>
     */
    public class CallsSuperAnswer implements Answer
	{
		/**
		 * Constructor.
		 */
		public function CallsSuperAnswer()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function invoke(invocation:Invocation):*
		{
			invocation.proceed();
			return undefined;
		}
	}
}
