package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    /**
     * Factory interface to prepare and create Mockolate instances.
     * 
     * @author drewbourne
     */
    public interface IMockolateFactory
    {
		function prepareClasses(classRecipes:ClassRecipes):IEventDispatcher;
		
		function prepareInstances(instanceRecipes:InstanceRecipes):IEventDispatcher;
		
		function prepareInstance(instanceRecipe:InstanceRecipe):InstanceRecipe;
		
//		[Deprecated]
//        /**
//         * Prepares the given Class references for use with the Mockolate library.
//         * 
//         * @param ...rest Class references to prepare proxies for.
//         * @returns IEventDispatcher to listen for <code>Event.COMPLETE</code> 
//         */
//        function prepare(... rest):IEventDispatcher;
//
//		[Deprecated]
//		/**
//		 * Prepares the given Class references for use with the Mockolate library.
//		 * 
//		 * @param ...rest Class references to prepare proxies for.
//		 * @returns IEventDispatcher to listen for <code>Event.COMPLETE</code> 
//		 */
//		function prepareClasses(toPrepare:Array):IEventDispatcher;
//
//		[Deprecated]
//		/**
//		 * Prepares a Class reference for use with the Mockolate library.
//		 * 
//		 * @param classReference Class to prepare a proxy. 
//		 * @param namespacesToProxy Array of QName for namespaces within which methods and properties should be proxied. 
//		 * @returns IEventDispatcher to listen for <code>ProxyClassEvent.PROXY_CLASS_PREPARED</code> 
//		 */
//		function prepareClassWithNamespaces(classReference:Class, namespacesToProxy:Array):IEventDispatcher
//			
//		[Deprecated]
//		/**
//		 * Gets the Class previously prepared with <code>prepare()</code> or <code>prepareClassWithNamespaces()</code>.
//		 * 
//		 * @param classReference Class to find a prepared Class for. 
//		 * @param proxiedNamespaces Array of QName for namespaces that were given with the class to <code>prepareClassWithNamespaces()</code>.  
//		 * @returns prepared Class or <code>null</code> if not yet prepared. 
//		 */
//		function preparedClassFor(classReference:Class, proxiedNamespaces:Array = null):Class
//        
//		[Deprecated]
//        /**
//         * Create an instance of Mockolate for the given Class reference.
//         * 
//         * Attempting to call <code>create()</code> before <code>prepare()</code> 
//         * has completed for that class will throw an Error.  
//         * 
//		 * @param mockType MockType to create the instance as.
//         * @param classReference Class reference that has been given to <code>prepare()</code>.
//         * @param constructorArgs Array of args to pass to the target instances constructor.
//         * @param name Name of the Mockolate instance to aid with debugging. 
//         * @returns Mockolate instance.
//         * 
//         * @see Mockolate#isStrict
//         */
//        function create(mockType:MockType, classReference:Class, constructorArgs:Array=null, name:String=null):Mockolate;
//		
//		[Deprecated]
//		function createWithProxyClass(mockType:MockType, classReference:Class, proxyClass:Class, constructorArgs:Array=null, name:String=null):Mockolate;
    }
}