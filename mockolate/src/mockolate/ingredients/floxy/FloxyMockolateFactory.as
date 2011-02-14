package mockolate.ingredients.floxy
{
    import asx.array.repeat;
    
    import flash.events.IEventDispatcher;
    import flash.system.ApplicationDomain;
    
    import mockolate.ingredients.AbstractMockolateFactory;
    import mockolate.ingredients.IMockolateFactory;
    import mockolate.ingredients.MockType;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.Mockolatier;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.flemit.reflection.Type;
    import org.floxy.IProxyRepository;
    import org.floxy.ProxyRepository;
    
    use namespace mockolate_ingredient;
    
    /**
     * MockolateFactory implementation using FLoxy to generate Class proxies. 
     */
    public class FloxyMockolateFactory extends AbstractMockolateFactory implements IMockolateFactory
    {
        private var _proxyRespository:IProxyRepository;
		private var _mockolatier:Mockolatier;
		private var _applicationDomain:ApplicationDomain;
        
        /**
         * Constructor. 
         */
        public function FloxyMockolateFactory(mockolatier:Mockolatier, applicationDomain:ApplicationDomain = null)
        {
            _proxyRespository = new ProxyRepository();
			_mockolatier = mockolatier;
			_applicationDomain = applicationDomain;
        }
        
        /**
         * @inheritDoc 
         */
        public function prepare(... rest):IEventDispatcher
        {
            return _proxyRespository.prepare(rest, _applicationDomain);
        }
        
        /**
         * @inheritDoc 
         */
        public function create(mockType:MockType, klass:Class, constructorArgs:Array=null, name:String=null):Mockolate
        {
			if (!constructorArgs)
				constructorArgs = repeat(null, Type.getType(klass).constructor.parameters.length);
				
            var mockolate:FloxyMockolate = createMockolate(mockType || MockType.STRICT, name) as FloxyMockolate;
            var target:* = _proxyRespository.create(klass, constructorArgs || [], mockolate.interceptor);
            mockolate.target = target;
            mockolate.targetClass = klass;
            return mockolate;
        }
        
        /**
         * @private 
         */
        protected function createMockolate(mockType:MockType, name:String=null):Mockolate
        {
            var mockolate:FloxyMockolate = new FloxyMockolate(name);
            mockolate.mockType = mockType;
            mockolate.interceptor = createInterceptor(mockolate);
            mockolate.recorder = createRecorder(mockolate);
            mockolate.mocker = createMocker(mockolate);
            mockolate.verifier = createVerifier(mockolate);
			mockolate.expecter = createExpecter(mockolate);
            return mockolate;
        }
		
		/**
		 * @private 
		 */
		protected function createInterceptor(mockolate:Mockolate):InterceptingCouverture
		{
			return new InterceptingCouverture(mockolate, _mockolatier);
		}
    }
}