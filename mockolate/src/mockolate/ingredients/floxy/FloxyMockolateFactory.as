package mockolate.ingredients.floxy
{
    import flash.events.IEventDispatcher;
    
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.MockolateFactory;
    import mockolate.ingredients.RecordingCouverture;
    import mockolate.ingredients.StubbingCouverture;
    import mockolate.ingredients.VerifyingCouverture;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IProxyRepository;
    import org.floxy.ProxyRepository;
    
    use namespace mockolate_ingredient;
    
    public class FloxyMockolateFactory implements MockolateFactory
    {
        private var _proxyRespository:IProxyRepository;
        
        public function FloxyMockolateFactory()
        {
            _proxyRespository = new ProxyRepository();
        }
        
        public function prepare(... rest):IEventDispatcher
        {
            return _proxyRespository.prepare(rest);
        }
        
        public function create(klass:Class, constructorArgs:Array=null, asStrict:Boolean=true, name:String=null):Mockolate
        {
            var mockolate:FloxyMockolate = createMockolate(asStrict, name) as FloxyMockolate;
            var target:* = _proxyRespository.create(klass, constructorArgs || [], mockolate.interceptor);
            mockolate.target = target;
            return mockolate;
        }
        
        protected function createMockolate(asStrict:Boolean=false, name:String=null):Mockolate
        {
            var mockolate:FloxyMockolate = new FloxyMockolate(name);
            mockolate.isStrict = asStrict;
            
            mockolate.interceptor = createInterceptor(mockolate);
            mockolate.recorder = createRecorder(mockolate);
            mockolate.stubber = createStubber(mockolate);
            mockolate.verifier = createVerifier(mockolate);
            
            return mockolate;
        }
        
        /**
         *
         */
        protected function createInterceptor(mockolate:Mockolate):InterceptingCouverture
        {
            return new InterceptingCouverture(mockolate);
        }
        
        /**
         *
         */
        protected function createRecorder(mockolate:Mockolate):RecordingCouverture
        {
            return new RecordingCouverture(mockolate);
        }
        
        /**
         *
         */
        protected function createStubber(mockolate:Mockolate):StubbingCouverture
        {
            return new StubbingCouverture(mockolate);
        }
        
        /**
         *
         */
        protected function createVerifier(mockolate:Mockolate):VerifyingCouverture
        {
            return new VerifyingCouverture(mockolate);
        }
    }
}