package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    import mockolate.ingredients.Sequence;
    
    /**
     * Creates a Sequence for use with ordered mocks and stubs.
     * 
     * @param name Name for the mock instance.
     * 
     * @see mockolate.ingredients.MockingCouverture#ordered()
	 * @see mockolate.ingredients.Sequence
     * 
     * @example
     * <listing version="3.0">
     *  var seq:Sequence = sequence("hello");
     * </listing>
     * 
     * @author drewbourne
     */
    public function sequence(name:String = null):*
    {
        return new Sequence(name);
    }
}
