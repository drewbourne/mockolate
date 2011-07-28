package mockolate.ingredients
{
    import asx.array.filter;
    import asx.array.flatten;
    import asx.array.forEach;
    import asx.array.map;
    import asx.array.unique;
    import asx.object.isA;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;
    
    import mockolate.errors.MockolateError;
    import mockolate.ingredients.bytecode.BytecodeProxyMockolateFactory;
    import mockolate.ingredients.floxy.FloxyMockolateFactory;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.collection.emptyArray;
    import org.hamcrest.collection.everyItem;
    import org.hamcrest.core.not;
    
    use namespace mockolate_ingredient;
    
    /**
     * Maker of the Mockolates.
     * 
     * Used by MockolatierMaster and the <code>mockolate.* </code> package-level functions.
     * 
     * Do not reference directly.  
     * 
     * @author drewbourne
     */
    public class Mockolatier extends EventDispatcher
    {
		private var _applicationDomain:ApplicationDomain;
        private var _mockolates:Array;
        private var _mockolatesByTarget:Dictionary;
        private var _mockolateFactory:IMockolateFactory;
		private var _lastInvocation:Invocation;
		private var _preparedClassRecipes:ClassRecipes;
        
        /**
         * Constructor.
         */
        public function Mockolatier()
        {
            super();
            
			_applicationDomain = ApplicationDomain.currentDomain;
            _mockolates = [];
            _mockolatesByTarget = new Dictionary();
            _mockolateFactory = new FloxyMockolateFactory(this, _applicationDomain);
			_preparedClassRecipes = new ClassRecipes();
        }
		
		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		public function set applicationDomain(value:ApplicationDomain):void 
		{
			_applicationDomain = value;
		}
		
		public function get mockolateFactory():IMockolateFactory 
		{
			return _mockolateFactory;
		}
		
		public function set mockolateFactory(value:IMockolateFactory):void
		{
			_mockolateFactory = value;
		}
		
        /**
         * Prepares the given Class references for creating proxy instances. 
         *  
         * @see mockolate#prepare()
         */
        public function prepare(... rest):IEventDispatcher
        {
			var classes:Array;
			classes = flatten(rest);
			classes = filter(classes, isA(Class)); 
			classes = unique(classes);
			
			if (classes.length == 0)
			{
				throw new ArgumentError("No Classes to prepare");
			}
			
			var classRecipes:ClassRecipes = new ClassRecipes();
			
			for each (var classToPrepare:Class in classes)
			{
				classRecipes.add(aClassRecipe().withClassToPrepare(classToPrepare).build());
			}
			
			return prepareClassRecipes(classRecipes);
        }
		
		/**
		 * 
		 */
		public function prepareClassRecipes(classRecipes:ClassRecipes):IEventDispatcher
		{
			var preparer:IEventDispatcher = _mockolateFactory.prepareClasses(classRecipes);
			preparer.addEventListener(Event.COMPLETE, addToPreparedClassRecipes(classRecipes), false, 100, true);
			return preparer;
		}
		
		private function addToPreparedClassRecipes(classRecipes:ClassRecipes):Function 
		{
			return function(event:Event):void 
			{
				forEach(classRecipes.toArray(), _preparedClassRecipes.add);
			}
		}

        /**
         * @see mockolate#nice()
         */
        public function nice(classReference:Class, name:String=null, constructorArgs:Array=null):*
        {
			var instanceRecipe:InstanceRecipe = anInstanceRecipe()
				.withClassRecipe(_preparedClassRecipes.getRecipeFor(classReference))
				.withName(name)
				.withConstructorArgs(constructorArgs)
				.withMockType(MockType.NICE)
				.build();
			
			return prepareInstance(instanceRecipe);
        }
		
        /**
         * @see mockolate#strict()
         */
        public function strict(classReference:Class, name:String=null, constructorArgs:Array=null):*
        {
			var instanceRecipe:InstanceRecipe = anInstanceRecipe()
				.withClassRecipe(_preparedClassRecipes.getRecipeFor(classReference))
				.withName(name)
				.withConstructorArgs(constructorArgs)
				.withMockType(MockType.STRICT)
				.build();
			
			return prepareInstance(instanceRecipe);
        }
		
		/**
		 * @see mockolate#partial()
		 */
		public function partial(classReference:Class, name:String=null, constructorArgs:Array=null):*
		{
			var instanceRecipe:InstanceRecipe = anInstanceRecipe()
				.withClassRecipe(_preparedClassRecipes.getRecipeFor(classReference))
				.withName(name)
				.withConstructorArgs(constructorArgs)
				.withMockType(MockType.PARTIAL)
				.build();
			
			return prepareInstance(instanceRecipe);
		}
		
		public function prepareInstances(instanceRecipes:InstanceRecipes):IEventDispatcher
		{
			var preparer:IEventDispatcher = _mockolateFactory.prepareInstances(instanceRecipes);
			preparer.addEventListener(Event.COMPLETE, addToRegisteredMockolaters(instanceRecipes), false, 100, true);
			return preparer;
		}
		
		private function addToRegisteredMockolaters(instanceRecipes:InstanceRecipes):Function
		{
			return function(event:Event):void 
			{
				forEach(instanceRecipes.toArray(), function(instanceRecipe:InstanceRecipe):void {
					registerTargetMockolate(instanceRecipe.instance, instanceRecipe.mockolate);
				});
			}
		}
		
		public function prepareInstance(instanceRecipe:InstanceRecipe):*
		{
			_mockolateFactory.prepareInstance(instanceRecipe);
			
			registerTargetMockolate(instanceRecipe.instance, instanceRecipe.mockolate);
			
			return instanceRecipe.instance;
		}
		
        /**
         * @see mockolate#mock()
         */
        public function mock(instance:*):MockingCouverture
        {
            return mockolateByTarget(instance).mocker.mock();
        }
        
        /**
         * @see mockolate#stub()
         */
        public function stub(instance:*):MockingCouverture
        {
            return mockolateByTarget(instance).mocker.stub();
        }
        
        /**
         * @see mockolate#verify()
         */
        public function verify(instance:*):VerifyingCouverture
        {
        	return mockolateByTarget(instance).verify().verifier;
        }
		
		/**
		 * @see mockolate#record()
		 */
		public function record(instance:*, script:Function=null):* 
		{
			mockolateByTarget(instance).record();
			return instance;
		}
		
		/**
		 * @see mockolate#replay()
		 */
		public function replay(instance:*):* 
		{
			mockolateByTarget(instance).replay();
			return instance;
		}
		
		/**
		 * @see mockolate#expect()
		 */
		public function expect(instance:*):ExpectingCouverture
		{
			// calls to expect must happen after an invocation 
			// as the invocation type, and arguments is used
			// when adding the expectation.
			
			if (!_lastInvocation)
				throw new MockolateError(["Unable to expect(), no Mockolate invocation has been recorded yet."], null, null);
			
			var args:Array = _expectArgs || _lastInvocation.arguments;
			_expectArgs = null;
			
			return mockolateByTarget(_lastInvocation.target).expecter.expect(_lastInvocation, args);
		}
		
		private var _expectArgs:Array;
		
		/**
		 * @see mockolate#expectArgs()
		 */
		public function expectArg(value:*):* 
		{
			_expectArgs ||= [];
			_expectArgs.push(value);
			
			return null;
		}
        
        /**
         * Checks the args Array matches the given Matcher, throws an ArgumentError if not.
         *
         * @param args
         * @param matcher
         * @param errorMessage
         * @throw ArgumentError
         */
        protected function check(args:Array, matcher:Matcher, errorMessage:String):void
        {
            if (!matcher.matches(args))
            {
                throw new ArgumentError(errorMessage);
            }
        }
		
//        /**
//         * Creates a proxied instance of the given Class and an associated 
//         * Mockolate instance.
//         * 
//         * @param classReference
//         * @param constructorArgs
//         * @param asStrict
//         * @param name  
//         * 
//         * @private
//         */
//		mockolate_ingredient function createTarget(mockType:MockType, classReference:Class, constructorArgs:Array=null, name:String=null):*
//        {
//            var instance:Mockolate = _mockolateFactory.create(mockType, classReference, constructorArgs, name);
//            var target:* = instance.target;
//            
//            registerTargetMockolate(target, instance);
//            
//            return target;
//        }
//		
//		/**
//		 * Creates a proxied instance of the given Class and an associated 
//		 * Mockolate instance.
//		 * 
//		 * @param classReference
//		 * @param constructorArgs
//		 * @param asStrict
//		 * @param name  
//		 * 
//		 * @private
//		 */
//		mockolate_ingredient function createTargetWithProxyClass(mockType:MockType, classReference:Class, proxyClass:Class, constructorArgs:Array=null, name:String=null):*
//		{
//			var instance:Mockolate = _mockolateFactory.createWithProxyClass(mockType, classReference, proxyClass, constructorArgs, name);
//			var target:* = instance.target;
//			
//			registerTargetMockolate(target, instance);
//			
//			return target;
//		}
		
		/**
		 * Registers the target and mockolate to allow a Mockolate instance to 
		 * be found by the target.
		 * 
		 * @see mockolateByTarget()
		 * 
		 * @private
		 */
		mockolate_ingredient function registerTargetMockolate(target:Object, instance:Mockolate):Mockolate 
		{
			_mockolates.push(instance);
			_mockolatesByTarget[target] = instance;
			
			return instance;
		}
        
        /**
         * Finds a Mockolate instance by its target instance.
         * 
         * Throws a MockolateNotFoundError when there is no Mockolate for the given target. 
         * 
         * @private
         */
		mockolate_ingredient function mockolateByTarget(target:*):Mockolate
        {
            var mockolate:Mockolate = _mockolatesByTarget[target];
            if (!mockolate)
			{
                throw new MockolateError(
					["No Mockolate for that target, received:{}", [target]], 
					null, target);
			}
            
            return mockolate;
        }
		
		/**
		 * Invokes a Mockolate.
		 * 
		 * @private
		 */
		mockolate_ingredient function invoked(invocation:Invocation):void 
		{
			// constructor invocations are too early for any expectations
			// to be setup yet so ignore them for now. 
			if (invocation.invocationType.isConstructor)
			{
				return;
			}
			
			_lastInvocation = invocation;
			
			mockolateByTarget(invocation.target).invoked(invocation);
		}
    }
}
