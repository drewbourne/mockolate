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
     *  var seq:Sequence = sequence("mix");
     *  var target: = nice(Flavour);
     *  mock(target).method("combine").args(hasProperties({ name: "chocolate" })).returns(target).ordered(seq);
     *  mock(target).method("toString").returns("chocolate").ordered(seq);
     *  mock(target).method("combine").args(hasProperties({ name: "coffee" })).returns(target).ordered(seq);
     *  mock(target).method("toString").returns("mocha").ordered(seq);
     * </listing>
     * 
     * @author drewbourne
     */
    public function sequence(name:String = null):*
    {
        return new Sequence(name);
    }
}
