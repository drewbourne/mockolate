package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * Creates an instance of the given Class and an associated Mockolate for
     * that instance. Returns the instance of the given Class.
     * 
     * @param klass Class to create a nice mock for.
     * @param name Name for the mock instance.
     * @erturn Instance of given Class.
     * 
     * @see mockolate#mock()
     * @see mockolate#stub()
     * 
     * @example
     * <listing version="3.0">
     *  var flavour:Flavour = nice(Flavour);
     * </listing>
     */
    public function make(klass:Class, name:String=null, constructorArgs:Array=null):*
    {
        return MockolatierMaster.nice(klass, name, constructorArgs);
    }
}
