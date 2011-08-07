package mockolate
{
    import mockolate.ingredients.ExpectingCouverture;
    import mockolate.ingredients.MockolatierMaster;

	/**
	 * Adds an Expectation that will not be verified.
	 * 
	 * @see mockolate.ingredients.Expectation
	 * @see mockolate#arg()
	 * 
	 * @example
	 * <listing version="3.0">
	 *  var flavour:Flavour = nice(Flavour);
	 *  var other:Flavour = nice(Flavour);
	 * 
	 *  // set a `setter` expectation 
	 *  allow(flavour.liked = true);
	 * 
	 *  // set a `getter` expectation
	 * 	allow(flavour.name).returns("butterscotch");
	 * 
	 * 	// set a `method` expectation
	 * 	allow(flavour.combine(other)).returns(flavour);
	 * 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
    public function allow(target:*):ExpectingCouverture
    {
        return MockolatierMaster.mockolatier.allow(target);
    }
}
