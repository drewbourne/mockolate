package mockolate
{
	import mockolate.ingredients.MockolatierMaster;

	[Deprecated]
	/**
	 * @param target Object created with nice() or strict()
	 * @param closure Function of expectations to record for the target 
	 * 
	 * @see mockolate#expect()
	 * @see mockolate#replay()
	 * 
	 * @example
	 * <listing version="3.0">
	 *	var flavour:Flavour = nice(Flavour);
	 *	var other:Flavour = nice(Flavour);
	 *	record(flavour);
	 *	expect(flavour.combine(other)).returns(flavour);
	 *	replay(flavour);
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public function record(target:*, script:Function=null):*
	{
	}
}
