package mockolate
{
    import asx.array.filter;
    import asx.array.reject;
    import asx.object.isA;
    
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    import mockolate.ingredients.MockolatierMaster;
    
	[Deprecated]
	
    /**
     * Prepares a Class for use with Mockolate.
     * 
     * Classes are prepared asynchronously. <code>prepareClassWithNamespaces()</code> returns an IEventDispatcher
     * that will fire an <code>Event.COMPLETE</code> event when finished preparing.  
     * 
     * @param classReference Class to prepare a proxy Class for
	 * @param namespacesToProxy Array of QName for the non-public namespaces of methods and properties to proxy.
     * @return IEventDispatcher
     * 
     * @see mockolate#nice()
     * @see mockolate#strict()  
     * 
     * @example
     * <listing version="3.0">
     *	prepareWithNamespaces(TopSecret, [ for_your_eyes_only ]);
     * </listing> 
     * 
     * @author drewbourne
     */
    public function prepareClassWithNamespaces(classReference:Class, namespacesToProxy:Array):IEventDispatcher
    {
		return null;
//        return MockolatierMaster.prepareClassWithNamespaces(classReference, namespacesToProxy);
    }
}
