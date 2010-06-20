package mockolate
{
    import mockolate.ingredients.ExpectingCouverture;
    import mockolate.ingredients.MockolatierMaster;

	/**
	 * @param target 
	 * 
	 * @see mockolate#expect()
	 * 
	 * @example
	 * <listing version="3.0">
	 * </listing>
	 * 
	 * @author drewbourne
	 */
    public function expectArg(value:*):*
    {
        return MockolatierMaster.expectArg(value);
    }
}
