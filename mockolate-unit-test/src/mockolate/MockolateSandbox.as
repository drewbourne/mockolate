package mockolate
{
    import asx.string.substitute;
    
    import flash.events.Event;
    
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.faux.FauxFloxyInterceptor;
    import mockolate.ingredients.floxy.InterceptingCouverture;
    import mockolate.sample.Flavour;
    
    import org.flexunit.async.Async;
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    import org.floxy.ProxyRepository;
    
    public class MockolateSandbox
    {
        private var repo:ProxyRepository;
        
        [Test(async, timeout=5000)]
        public function floxyWeirdness():void
        {
            repo = new ProxyRepository();
            Async.handleEvent(this, repo.prepare([ Flavour ]), Event.COMPLETE, floxyWeirdnessContinued);
        }
        
        public function floxyWeirdnessContinued(event:Event, ... rest):void
        {
//            var mock:Mockolate = new FauxMockolate(function(invocation:Invocation):void
//                {
//                    trace('invocation', invocation);
//                });
//            
//            var interceptor:InterceptingCouverture = new InterceptingCouverture(mock);
            
            var interceptor:IInterceptor = new FauxFloxyInterceptor(function(invocation:IInvocation):void
                {
                    trace('intercept', invocation);
                    if (invocation.property)
                    {
                        trace(substitute('intercept property name:{}, ns:{} fullname:{} qname:{}',
                            invocation.property.name,
                            invocation.property.qname.ns,
                            invocation.property.fullName,
                            invocation.property.qname));
                    }
                    else
                    {
                        trace(substitute('intercept method name:{}, ns:{} fullname:{} qname:{}',
                            invocation.method.name,
                            invocation.method.qname.ns,
                            invocation.method.fullName,
                            invocation.method.qname));
                    }
                });
            
            var flavour:Flavour = repo.create(Flavour, [], interceptor) as Flavour;
            
            flavour.ingredients = [ "ice", "cream", "vanilla" ];
        }
    }
}
