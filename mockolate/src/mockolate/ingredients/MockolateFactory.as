package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    /**
     *
     */
    public interface MockolateFactory
    {
        /**
         *
         */
        function prepare(... rest):IEventDispatcher;
        
        /**
         *
         */
        function create(klass:Class, constructorArgs:Array=null, asStrict:Boolean=true, name:String=null):Mockolate;
    }
}