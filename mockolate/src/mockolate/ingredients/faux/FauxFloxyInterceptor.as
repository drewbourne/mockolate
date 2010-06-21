package mockolate.ingredients.faux
{
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
	/**
	 * FauxFloxyInterceptor forwards the <code>IInterceptor.intercept()</code>
	 * to a provided Function.
	 * 
	 * Used for testing.
	 * 
	 * @private
	 * @author drewbourne
	 */
    public class FauxFloxyInterceptor implements IInterceptor
    {
        private var _interceptHandler:Function;
        
		/**
		 * Constructor.
		 *  
		 * @param interceptorHandler Function to forward an intercepted IInvocation to.
		 */
        public function FauxFloxyInterceptor(interceptorHandler:Function)
        {
            super();
            
            _interceptHandler = interceptorHandler;
        }
        
		/**
		 * Handle an intercepted IInvocation by forwarding to the interceptorHandler
		 * given to the constructor. 
		 * 
		 * @param invocation
		 */
        public function intercept(invocation:IInvocation):void
        {
            _interceptHandler(invocation);
        }
    }
}