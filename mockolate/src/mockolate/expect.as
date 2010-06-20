package mockolate
{
    import mockolate.ingredients.ExpectingCouverture;
    import mockolate.ingredients.MockolatierMaster;

	/**
	 * When a Mockolate is recording, use expect() to set expectations.
	 * 
	 * @param target 
	 * 
	 * @see mockolate#record()
	 * @see mockolate#replay()
	 * @see mockolate#expectArg()
	 * 
	 * @example
	 * <listing version="3.0">
	 *  var flavour:Flavour = nice(Flavour);
	 *  var other:Flavour = nice(Flavour);
	 * 
	 *  // set the `flavour` mockolate to record mode
	 *  record(flavour);
	 * 
	 *  // set a `setter` expectation 
	 *  expect(flavour.liked = true);
	 * 
	 *  // set a `getter` expectation
	 * 	expect(flavour.name).returns("butterscotch");
	 * 
	 * 	// set a `method` expectation
	 * 	expect(flavour.combine(other)).returns(flavour);
	 * 
	 *  // set the `flavour` mockolate to replay mode
	 *  replay(flavour);
	 * </listing>
	 * 
	 * @author drewbourne
	 */
    public function expect(target:*):ExpectingCouverture
    {
        return MockolatierMaster.expect(target);
    }
}
