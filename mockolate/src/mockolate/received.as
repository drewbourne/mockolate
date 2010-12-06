package mockolate
{
	import mockolate.ingredients.InvocationsMatcher;

	/**
	 * Creates a Matcher that can be used to checks the recorded invocations for
	 * the Mockolate-created instance that is being matched. 
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	var flavour1:Flavour = nice(Flavour);
	 * 	var flavour2:Flavour = nice(Flavour);
	 * 
	 * 	flavour1.combine(flavour2);
	 * 
	 * 	assertThat(flavour1, received().method('combine').args(flavour2).once());
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public function received():InvocationsMatcher
	{
		return new InvocationsMatcher();
	}
}