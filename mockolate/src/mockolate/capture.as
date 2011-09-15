package mockolate
{
	import mockolate.ingredients.Capture;
	import mockolate.ingredients.CaptureMatcher;

	/**
	 * Creates a CaptureMatcher that will captures the value of an argument 
	 * when an expectation is invoked.
	 * 
	 * @param capture Capture instance that will store the value
	 * 
	 * @return CaptureMatcher
	 * 
	 * @see mockolate.ingredients.Capture
	 * @see mockolate.ingredients.CaptureMatcher
	 * 
	 * @example
	 * <listing version="3.0">
	 *	var captured:Capture = new Capture();
	 *	var flavourA:Flavour = nice(Flavour);
	 *	var flavourB:Flavour = nice(Flavour);
	 *	
	 *	mock(flavourA).method("combine").args(capture(captured));
	 * 
	 *	flavourA.combine(flavourB);
	 * 
	 *	assertThat(captured.value, strictlyEqualTo(flavourB));
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public function capture(capture:Capture):CaptureMatcher
	{
		return new CaptureMatcher(capture);
	}
}