package mockolate.errors
{
	import mockolate.ingredients.Mockolate;

	/**
	 * Verification-related Error
	 */
	public class VerificationError extends MockolateError
	{
		/**
		 * Constructor.
		 */
		public function VerificationError(
			message:Object, 
			mockolate:Mockolate, 
			target:Object)
		{
			super(message, mockolate, target);
		}
	}
}