package mockolate
{
    import mockolate.ingredients.MockolatierMaster;

    /**
     * Creates an instance of the given Class that will behave as a 'partial' mock. 
     * 
     * When a Mockolate is 'partial' it will call the super method or property unless an Expectation has been defined.
     * 
     * @param classReference Class to create a partial mock for.
     * @param name Name for the mock instance.
     * @param constructorArgs Array of Objects to pass to the Class constructor.
     * 
     * @see mockolate#partial()
     * @see mockolate#mock()
     * @see mockolate#stub()
     * 
     * @example
     * <listing version="3.0">
     *  var flavour:Flavour = partial(Flavour);
     * </listing>
     * 
     * @author drewbourne
     */
    public function partial(classReference:Class, name:String=null, constructorArgs:Array=null):*
    {
        return MockolatierMaster.partial(classReference, name, constructorArgs);
    }
}
