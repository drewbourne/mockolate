package mockolate.ingredients.constraints
{
	/**
	 * Interface for constraining when an Expectation is eligible. 
	 * 
	 * @author drewbourne
	 */
	public interface Constraint
	{
		/**
		 * Indicates if the Invocation is allowed.
		 */
		function isInvocationAllowed():Boolean;
	}
}