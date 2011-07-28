package mockolate
{
    import mockolate.ingredients.ExpectingCouverture;
    import mockolate.ingredients.MockolatierMaster;

	/**
	 * When using expect(), use expectArg() to use hamcrest-as3 Matchers 
	 * for arguments. 
	 * 
	 * @param value Value or Matcher that is expected.   
	 * 
	 * @see mockolate#expect()
	 * 
	 * @example
	 * <listing version="3.0">
	 * 
	 * 	record(flavour);
	 * 	expect(flavour.combine(expectArg(isA(Flavour)).once();
	 * 	replay(flavour);
	 * 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
    public function expectArg(value:*):*
    {
        return MockolatierMaster.mockolatier.expectArg(value);
    }
}
