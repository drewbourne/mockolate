package mockolate.ingredients.faux
{
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.Mockolatier;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
    public class FauxMockolatier extends Mockolatier
    {
        private var _invokedHandler:Function;
        
        public function FauxMockolatier(invokedHandler:Function)
        {
			super();
            _invokedHandler = invokedHandler;
        }
        
        override mockolate_ingredient function invoked(invocation:Invocation):void
        {
            _invokedHandler(invocation);
        }
    }
}
