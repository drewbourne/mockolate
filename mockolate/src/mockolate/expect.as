package mockolate
{
    import mockolate.ingredients.ExpectingCouverture;
    import mockolate.ingredients.MockolatierMaster;

	/**
	 * @param target 
	 * 
	 * @see mockolate#record()
	 * @see mockolate#replay()
	 * 
	 * @example
	 * <listing version="3.0">
	 *  var flavour:Flavour = nice(Flavour);
	 *  var other:Flavour = nice(Flavour);
	 *  record(flavour);
	 *  expect(flavour.combine(other)).returns(flavour);
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
