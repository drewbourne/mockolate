package mockolate.ingredients
{
	/**
	 * Features for mocking and stubbing Setters.
	 *  
	 * @author drew
	 */
	public interface IMockingSetterCouverture extends IMockingCouverture
	{
		/**
		 * Use <code>arg()</code> to define a single value or Matcher as the 
		 * expected arguments. Typically used with property expectations to 
		 * define the expected argument value for the property setter.
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).property("enabled").arg(Boolean);
		 * </listing> 
		 */
		function arg(value:Object):IMockingSetterCouverture;
	}
}