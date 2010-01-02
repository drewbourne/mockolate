package mockolate
{
    import mockolate.ingredients.MockolatierMaster;

    /**
     * Creates an instance of the given Class that will behave as a 'strict' mock. 
     * 
     * @param klass Class to create a strict mock for.
     * @param name Name for the mock instance.
     * 
     * @example
     * <listing version="3.0">
     *  var flavour:Flavour = nice(Flavour);
     */
    public function strict(klass:Class, name:String=null):*
    {
        return MockolatierMaster.strict(klass, name);
    }
}
