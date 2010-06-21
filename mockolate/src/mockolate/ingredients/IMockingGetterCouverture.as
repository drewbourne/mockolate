package mockolate.ingredients
{
	/**
	 * Features for mocking and stubbing Getters.
	 * 
	 * @author drewbourne
	 */
	public interface IMockingGetterCouverture extends IMockingCouverture
	{		
		/**
		 * Sets the value to return when the current Expectation is invoked.  
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("toString").returns("[Instance]");
		 * 
		 *	trace(instance.toString());
		 *	// "[Instance]" 
		 * </listing>
		 */
		function returns(value:*, ...values):IMockingCouverture;
	}
}