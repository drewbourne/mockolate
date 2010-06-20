package mockolate.ingredients.floxy
{
    import asx.string.substitute;
    
    import mockolate.ingredients.Couverture;
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.Mockolatier;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
    /**
     * FLoxy IInterceptor implementation for Mockolate. 
     */
    public class InterceptingCouverture extends Couverture implements IInterceptor
    {
		private var _mockolatier:Mockolatier;
		
    	/**
    	 * Constructor.
    	 */
        public function InterceptingCouverture(mockolate:Mockolate, mockolatier:Mockolatier)
        {
            super(mockolate);
			
			_mockolatier = mockolatier;
        }
        
        /**
         * Called by FLoxy proxy instances.
         * 
         * @private  
         */
        public function intercept(invocation:IInvocation):void
        {
			_mockolatier.invoked(new FloxyInvocation(invocation));
        }
    }
}
