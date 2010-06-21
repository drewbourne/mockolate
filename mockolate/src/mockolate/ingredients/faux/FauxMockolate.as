package mockolate.ingredients.faux
{
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
	/**
	 * FauxMockolate forwards calls to <code>Mockolate.invoked()</code> to the
	 * invokedHandler Function given to the constructor.
	 * 
	 * @author drewbourne
	 */
    public class FauxMockolate extends Mockolate
    {
        private var _invokedHandler:Function;
        
		/**
		 * Constructor.
		 *  
		 * @param invokedHandler Function to forward <code>Invocation</code>s to
		 * @param name Name of this Mockolate
		 */
        public function FauxMockolate(invokedHandler:Function, name:String=null)
        {
            super(name);
            
            _invokedHandler = invokedHandler;
        }
        
		/**
		 * Forwards to the invokedHandler given to the constructor.
		 * 
		 * @param invocation
		 * @return this.
		 */
        override mockolate_ingredient function invoked(invocation:Invocation):Mockolate
        {
            _invokedHandler(invocation);
            return this;
        }
    }
}
