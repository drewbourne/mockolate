package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * @param klass Class to create a nice mock for.
     * @param name Name for the mock instance.
     */
    public function nice(klass:Class, name:String=null, constructorArgs:Array=null):*
    {
        // fixme, needs to be nice and take any of:
        // (klass:Class)
        // (klass:Class, constructorArgs:Array)
        // (klass:Class, name:String)
        // (klass:Class, name:String, constructorArgs:Array)
        
        return MockolatierMaster.nice(klass, name, constructorArgs);
    }
}
