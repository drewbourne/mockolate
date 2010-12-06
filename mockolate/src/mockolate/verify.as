package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    import mockolate.ingredients.VerifyingCouverture;
    
    // TODO verify() with no targets verifies all the mockolates
    
    /**
     * Verify Expectations and Invocations.
     * 
     * Calling <code>verify()</code> will verify that any Expectations defined
     * by <code>mock()</code> have been invoked their expected number of times.
     * 
     * Using the VerifyingCouverture additional verification can be performed
     * on the Invocations recorded by the Mockolate instance.
     * 
     * @see mockolate.ingredients.VerifyingCouverture
     * 
     * @example
     * <listing version="3.0">
     *  var target:Flavour = nice(Flavour);
     *  mock(target).method("combine").args(Flavour).returns(target);
     *  // use target
     *  verify(target);
     * </listing>
     * 
     * @author drewbourne
     */
    public function verify(target:*):VerifyingCouverture
    {
        return MockolatierMaster.verify(target);
    }
}
