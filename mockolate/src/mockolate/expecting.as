package mockolate
{
	import mockolate.ingredients.ExpectingCouverture;
	import mockolate.ingredients.MockolatierMaster;

	/**
	 * Executes a context within which Expectations are defined. 
	 * 
	 * When using strict instances expectations must be defined within an 
	 * expecting context to allow Mockolate to determine whether the invocation
	 * is to define an expectation or is for usage by the system under test.   
	 * 
	 * @see mockolate.ingredients.Expectation
	 * @see mockolate#expect()
	 * 
	 * @example
	 * <listing version="3.0">
	 *	var flavour:Flavour = nice(Flavour);
	 *	var other:Flavour = nice(Flavour);
	 * 
	 * 	expecting(function():void {
	 *		// set a `setter` expectation 
	 *		expect(flavour.liked = true);
	 * 
	 *		// set a `getter` expectation
	 *		expect(flavour.name).returns("butterscotch");
	 * 
	 *		// set a `method` expectation
	 *		expect(flavour.combine(other)).returns(flavour);
	 * 	});
	 * 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public function expecting(context:Function):void
	{
		MockolatierMaster.mockolatier.expecting(context);
	}
}
