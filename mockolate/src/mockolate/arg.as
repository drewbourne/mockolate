package mockolate
{
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
	 * 	expect(flavour.combine(arg(isA(Flavour)).once();
	 * 	replay(flavour);
	 * 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
    public function arg(value:*):*
    {
        return MockolatierMaster.mockolatier.expectArg(value);
    }
}
