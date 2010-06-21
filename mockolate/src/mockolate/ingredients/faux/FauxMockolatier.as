package mockolate.ingredients.faux
{
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.Mockolatier;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
	/**
	 * FauxMockolatier forwards calls to <code>Mockolatier.invoked()</code> to
	 * the invokedHandler Function given to the constructor.
	 * 
	 * @author drewbourne
	 */
    public class FauxMockolatier extends Mockolatier
    {
        private var _invokedHandler:Function;
        
		/**
		 * Constructor.
		 * 
		 * @param invokedHandler
		 */
        public function FauxMockolatier(invokedHandler:Function)
        {
			super();
            _invokedHandler = invokedHandler;
        }
        
		/**
		 * Forwards to the invokedHandler given to the constructor.
		 * 
		 * @param invocation
		 */
        override mockolate_ingredient function invoked(invocation:Invocation):void
        {
            _invokedHandler(invocation);
        }
    }
}
