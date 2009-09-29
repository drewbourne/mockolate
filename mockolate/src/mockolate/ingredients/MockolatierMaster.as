package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    /**
     *
     */
    public class MockolatierMaster
    {
        private static var _mockolatier:Mockolatier = new Mockolatier();
        
        public static function get mockolatier():Mockolatier
        {
            return _mockolatier;
        }
        
        public static function set mockolatier(value:Mockolatier):void
        {
            if (value)
            {
                _mockolatier = value;
            }
        }
        
        public static function prepare(... rest):IEventDispatcher
        {
            return mockolatier.prepare(rest);
        }
        
        public static function nice(klass:Class, name:String=null, constructorArgs:Array=null):*
        {
            return mockolatier.nice(klass, name, constructorArgs);
        }
        
        public static function strict(klass:Class, name:String=null, constructorArgs:Array=null):*
        {
            return mockolatier.strict(klass, name, constructorArgs);
        }
        
        public static function stub(target:* /*, propertyOrMethod:String*/):StubbingCouverture
        {
            return mockolatier.stub(target /*, propertyOrMethod*/);
        }
        
        public static function verify(target:* /*, propertyOrMethod:String=null*/):VerifyingCouverture
        {
            return mockolatier.verify(target /*, propertyOrMethod*/);
        }
    }
}