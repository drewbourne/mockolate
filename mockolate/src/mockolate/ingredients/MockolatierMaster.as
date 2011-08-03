package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    use namespace mockolate_ingredient;
    
    [ExcludeClass]
    
    /**
     * Oversees and delegates work to a Mockolatier.
     * 
     * Provides a static wrapper around a Mockolatier instance for use with the 
     * <code>mockolate.*</code> package functions. 
     * 
     * Do not reference directly.
     */
    public class MockolatierMaster
    {
        // create a default Mockolatier
        private static var _mockolatier:Mockolatier = new Mockolatier();
        
        /**
         * Mockolatier instance to use with the <code>mockolate.*</code> 
         * package-level functions. 
         */
        public static function get mockolatier():Mockolatier
        {
            return _mockolatier;
        }
        
        /** @private */
        public static function set mockolatier(value:Mockolatier):void
        {
            if (value)
            {
                _mockolatier = value;
            }
        }
    }
}