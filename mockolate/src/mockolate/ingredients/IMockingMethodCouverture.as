package mockolate.ingredients
{
	/**
	 * Features for mocking and stubbing Methods.
	 * 
	 * @author drewbourne
	 */
	public interface IMockingMethodCouverture extends IMockingCouverture
	{
		/**
		 * Use <code>args()</code> to define the values or Matchers to expect as
		 * arguments when the method (or property) is invoked. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("add").args(Number, Number).returns(42);
		 * </listing> 
		 */
		function args(...rest):IMockingMethodCouverture;

		/**
		 * Use <code>noArgs()</code> to define that arguments are not expected
		 * when the method is invoked.	
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("toString").noArgs();
		 * </listing> 
		 */
		function noArgs():IMockingMethodCouverture;

		/**
		 * Use <code>anyArgs()</code> to define that the current Expectation 
		 * should be invoked for any arguments.
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("arbitrary").anyArgs();
		 * 
		 *	instance.arbitrary(1, 2, 3);	
		 * </listing> 
		 */
		function anyArgs():IMockingMethodCouverture;

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