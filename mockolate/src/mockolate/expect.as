package mockolate
{
	import mockolate.ingredients.ExpectingCouverture;
	import mockolate.ingredients.MockolatierMaster;

	/**
	 * Adds an Expectation that will be verified.
	 * 
	 * @see mockolate.ingredients.Expectation
	 * @see mockolate#arg()
	 * 
	 * @example
	 * <listing version="3.0">
	 *	var flavour:Flavour = nice(Flavour);
	 *	var other:Flavour = nice(Flavour);
	 * 
	 *	// set a `setter` expectation 
	 *	expect(flavour.liked = true);
	 * 
	 *	// set a `getter` expectation
	 *	expect(flavour.name).returns("butterscotch");
	 * 
	 *	// set a `method` expectation
	 *	expect(flavour.combine(other)).returns(flavour);
	 * 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public function expect(target:*):ExpectingCouverture
	{
		return MockolatierMaster.mockolatier.expect(target);
	}
}
