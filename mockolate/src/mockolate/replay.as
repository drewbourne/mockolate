package mockolate
{
    import mockolate.ingredients.MockolatierMaster;

	/**
	 * @param target Object created with nice() or strict()
	 * 
	 * @see mockolate#expect()
	 * @see mockolate#record()
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
    public function replay(target:*):*
    {
        return MockolatierMaster.replay(target);
    }
}
