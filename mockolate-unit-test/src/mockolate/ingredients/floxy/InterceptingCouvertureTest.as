package mockolate.ingredients.floxy
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.RecordingCouverture;
    import mockolate.ingredients.faux.FauxFloxyInvocation;
    import mockolate.ingredients.faux.FauxInvocation;
    import mockolate.ingredients.faux.FauxMockolate;
    import mockolate.ingredients.floxy.InterceptingCouverture;
    import mockolate.ingredients.mockolate_ingredient;
    import mockolate.nice;
    import mockolate.prepare;
    import mockolate.sample.Flavour;
    import mockolate.verify;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.floxy.IInvocation;
    import org.floxy.SimpleInvocation;
    import org.hamcrest.collection.array;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.object.sameInstance;
    
    use namespace mockolate_ingredient;
    
    public class InterceptingCouvertureTest
    {
        private var _mockolate:Mockolate;
        private var interceptor:InterceptingCouverture;
        private var recorder:RecordingCouverture;
        private var invocation:Invocation;
        private var interceptedInvocation:IInvocation;
        
        [Test]
        public function shouldInterceptAndForwardInvocationToMockolate():void
        {
            var interceptedAndForwarded:Boolean = false;
            
            // FIXME dogfood it, replace with a Mockolate mock
            _mockolate = new FauxMockolate(function(invocation:Invocation):void
                {
                    interceptedAndForwarded = true;
                });
            
            interceptor = new InterceptingCouverture(_mockolate);
            interceptedInvocation = new FauxFloxyInvocation();
            
            interceptor.intercept(interceptedInvocation);
            
            assertThat(interceptedAndForwarded, equalTo(true));
        
            // verify(mockolate).method("mockolate_ingredient::invoked").args(instanceOf(Invocation)).once();
        }
    }
}
