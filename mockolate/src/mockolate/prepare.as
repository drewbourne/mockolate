package mockolate
{
    import flash.events.IEventDispatcher;
    
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * Prepares a Class for use with Mockolate.
     * 
     * Classes are prepared asynchronously. <code>prepare()</code> returns an IEventDispatcher
     * that will fire an <code>Event.COMPLETE</code> event when finished preparing.  
     * 
     * @param ...rest One or more Class references.
     * @return IEventDispatcher
     * 
     * @see mockolate#nice()
     * @see mockolate#strict()  
     * 
     * @example
     * <listing version="3.0">
     *	prepare(Chocolate, Milk, Sugar);
     * </listing> 
     * 
     * @author drewbourne
     */
    public function prepare(... rest):IEventDispatcher
    {
        return MockolatierMaster.mockolatier.prepare(rest);
    }
}
