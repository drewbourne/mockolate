package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * @param klass Class to create a strict mock for.
     * @param name Name for the mock instance.
     */
    public function strict(klass:Class, name:String=null):*
    {
        return MockolatierMaster.strict(klass, name);
    }
}
