package mockolate.errors
{
	import mockolate.ingredients.Expectation;
	import mockolate.ingredients.Mockolate;

	/**
	 * Expectation-related Error 
	 */
	public class ExpectationError extends MockolateError
	{
		private var _expectations:Array;
		
		/**
		 * Constructor.
		 * 
		 * @param message String or Array (String, ...Object) to be substituted.
		 * @param expectations Array of Expectation
		 * @param mockolate Mockolate instance
		 * @param target Object the Mockolate is mocking. 
		 */
		public function ExpectationError(
		    message:Object, 
		    expectations:Array, 
		    mockolate:Mockolate, 
		    target:Object)
		{
			super(message, mockolate, target);
			
			_expectations = expectations;
		}
		
		/**
		 * Expectations related to this Error
		 */
		public function get expectations():Array 
		{
		    return _expectations;
		}
	}
}