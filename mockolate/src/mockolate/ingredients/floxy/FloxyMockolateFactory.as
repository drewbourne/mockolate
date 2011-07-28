package mockolate.ingredients.floxy
{
    import asx.array.forEach;
    import asx.array.map;
    import asx.array.repeat;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.setTimeout;
    
    import mockolate.ingredients.AbstractMockolateFactory;
    import mockolate.ingredients.ClassRecipe;
    import mockolate.ingredients.ClassRecipes;
    import mockolate.ingredients.IMockolateFactory;
    import mockolate.ingredients.InstanceRecipe;
    import mockolate.ingredients.InstanceRecipes;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.Mockolatier;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.flemit.reflection.Type;
    import org.floxy.ProxyRepository;
    import org.floxy.event.ProxyClassEvent;
    
    use namespace mockolate_ingredient;
    
    /**
     * MockolateFactory implementation using FLoxy to generate Class proxies. 
     */
    public class FloxyMockolateFactory extends AbstractMockolateFactory implements IMockolateFactory
    {
		private var _mockolatier:Mockolatier;
		private var _applicationDomain:ApplicationDomain;
		private var _proxyRepository:ProxyRepository;
        
        /**
         * Constructor. 
         */
        public function FloxyMockolateFactory(mockolatier:Mockolatier, applicationDomain:ApplicationDomain = null)
        {
			_mockolatier = mockolatier;
			_applicationDomain = applicationDomain;
			_proxyRepository = new ProxyRepository();
        }
		
		public function prepareClasses(classRecipes:ClassRecipes):IEventDispatcher
		{
			var toPrepare:Array = map(classRecipes.toArray(), function(classRecipe:ClassRecipe):Array {
				return [ classRecipe.classToPrepare, classRecipe.namespacesToProxy ];
			}); 
			
			trace("FloxyMockolateFactory prepareClassRecipes", toPrepare);
			var bridge:IEventDispatcher = new EventDispatcher();
			
			var preparing:IEventDispatcher = _proxyRepository.prepareClasses(toPrepare, _applicationDomain);
			
			preparing.addEventListener(ProxyClassEvent.PROXY_CLASS_PREPARED, function(event:ProxyClassEvent):void {
				trace("FloxyMockolateFactory prepareClassRecipes prepared", event.proxyClassInfo.proxiedClass, event.proxyClassInfo.proxyClass);
				var classRecipe:ClassRecipe = classRecipes.getRecipeFor(
					event.proxyClassInfo.proxiedClass, 
					event.proxyClassInfo.proxiedNamespaces);
				trace("FloxyMockolateFactory prepareClassRecipes classRecipe", classRecipe);
				if (classRecipe) 
					classRecipe.proxyClass = event.proxyClassInfo.proxyClass;	
			});
			
			preparing.addEventListener(Event.COMPLETE, function(event:Event):void {
				trace("FloxyMockolateFactory prepareClassRecipes complete", toPrepare);
				setTimeout(bridge.dispatchEvent, 0, new Event(Event.COMPLETE));
			});
			return bridge;
		}
		
		public function prepareInstances(instanceRecipes:InstanceRecipes):IEventDispatcher
		{
			var bridge:IEventDispatcher = new EventDispatcher();
			
			forEach(instanceRecipes.toArray(), prepareInstance);
			
			setTimeout(bridge.dispatchEvent, 0, new Event(Event.COMPLETE));
			
			return bridge;
		}
		
		public function prepareInstance(instanceRecipe:InstanceRecipe):InstanceRecipe 
		{
			if (instanceRecipe)
			{
				instanceRecipe.mockolate = createMockolate(instanceRecipe);
				instanceRecipe.instance = createInstance(instanceRecipe);
				instanceRecipe.mockolate.target = instanceRecipe.instance;
				instanceRecipe.mockolate.targetClass = instanceRecipe.classRecipe.classToPrepare;
			}

			return instanceRecipe;
		}
        
        private function createMockolate(instanceRecipe:InstanceRecipe):Mockolate
        {
            var instance:FloxyMockolate = new FloxyMockolate(instanceRecipe.name);
			instance.mockType = instanceRecipe.mockType;
			instance.interceptor = createInterceptor(instance);
			instance.recorder = createRecorder(instance);
			instance.mocker = createMocker(instance);
			instance.verifier = createVerifier(instance);
			instance.expecter = createExpecter(instance);
            return instance;
        }
		
		private function createInterceptor(mockolate:Mockolate):InterceptingCouverture
		{
			return new InterceptingCouverture(mockolate, _mockolatier);
		}
		
		private function createInstance(instanceRecipe:InstanceRecipe):*
		{
			var constructorArgs:Array = createConstructorArgs(instanceRecipe);
			
			return _proxyRepository.createWithProxyClass(
				instanceRecipe.classRecipe.proxyClass, 
				constructorArgs, 
				(instanceRecipe.mockolate as FloxyMockolate).interceptor);
		}
		
		private function createConstructorArgs(instanceRecipe:InstanceRecipe):Array 
		{
			var constructorArgs:Array = instanceRecipe.constructorArgs;
			if (!constructorArgs)
			{
				constructorArgs = repeat(null, Type.getType(instanceRecipe.classRecipe.classToPrepare).constructor.parameters.length);
			}
			return constructorArgs;
		}
    }
}
