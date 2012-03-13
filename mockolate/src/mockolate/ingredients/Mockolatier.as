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
		private var _preparingClassRecipes:ClassRecipes;
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
			
			_preparingClassRecipes = new ClassRecipes();
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
		 * @see mockolate#prepare()
		 */
		mockolate_ingredient function prepareClassRecipes(classRecipes:ClassRecipes):IEventDispatcher
		{
			var dispatcher:IEventDispatcher;
			var classRecipesToPrepare:ClassRecipes = classRecipes.without(_preparingClassRecipes).without(_preparedClassRecipes);
			
			if (classRecipesToPrepare.numRecipes == 0)
			{
				dispatcher = new EventDispatcher();
				setTimeout(dispatcher.dispatchEvent, 0, new Event(Event.COMPLETE));
				return dispatcher;
			}
			else
			{
				addToPreparingClassRecipes(classRecipesToPrepare);
				dispatcher = _mockolateFactory.prepareClasses(classRecipesToPrepare);
				dispatcher.addEventListener(Event.COMPLETE, addToPreparedClassRecipes(classRecipesToPrepare), false, 100);
				return dispatcher;
			}
		}
		
		private function addToPreparingClassRecipes(classRecipes:ClassRecipes):void 
		{
			forEach(classRecipes.toArray(), _preparingClassRecipes.add);
		}
		
		private function addToPreparedClassRecipes(classRecipes:ClassRecipes):Function 
		{
			return function(event:Event):void 
			{
				forEach(classRecipes.toArray(), _preparingClassRecipes.remove);
				forEach(classRecipes.toArray(), _preparedClassRecipes.add);
			}
		}
		
		mockolate_ingredient function preparedClassRecipeFor(classToPrepare:Class, namespacesToProxy:Array):ClassRecipe 
		{
			return _preparedClassRecipes.getRecipeFor(classToPrepare, namespacesToProxy);
		}

        /**
         * @see mockolate#nice()
         */
        public function nice(classReference:Class, name:String=null, constructorArgs:Array=null):*
        {
			return prepareInstance(
				createInstanceRecipeFor(MockType.NICE, classReference, name, constructorArgs));
        }
		
        /**
         * @see mockolate#strict()
         */
        public function strict(classReference:Class, name:String=null, constructorArgs:Array=null):*
        {
			return prepareInstance(
				createInstanceRecipeFor(MockType.STRICT, classReference, name, constructorArgs));
        }
		
		/**
		 * @see mockolate#partial()
		 */
		public function partial(classReference:Class, name:String=null, constructorArgs:Array=null):*
		{
			return prepareInstance(
				createInstanceRecipeFor(MockType.PARTIAL, classReference, name, constructorArgs));
		}
		
		mockolate_ingredient function createInstanceRecipeFor(
			type:MockType, classReference:Class, name:String=null, constructorArgs:Array=null):InstanceRecipe
		{
			var instanceRecipe:InstanceRecipe = anInstanceRecipe()
				.withClassRecipe(_preparedClassRecipes.getRecipeFor(classReference))
				.withName(name)
				.withConstructorArgs(constructorArgs)
				.withMockType(type)
				.build();
			
			return instanceRecipe;
		}
		
		mockolate_ingredient function prepareInstances(instanceRecipes:InstanceRecipes):IEventDispatcher
		{
			var preparer:IEventDispatcher = _mockolateFactory.prepareInstances(instanceRecipes);
			preparer.addEventListener(Event.COMPLETE, addToRegisteredMockolates(instanceRecipes), false, 100);
			return preparer;
		}
		
		private function addToRegisteredMockolates(instanceRecipes:InstanceRecipes):Function
		{
			return function(event:Event):void 
			{
				forEach(instanceRecipes.toArray(), function(instanceRecipe:InstanceRecipe):void {
					registerTargetMockolate(instanceRecipe.instance, instanceRecipe.mockolate);
				});
			}
		}
		
		mockolate_ingredient function prepareInstance(instanceRecipe:InstanceRecipe):*
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
		 * @see mockolate#expecting()
		 */
		public function expecting(context:Function):void 
		{
			_isExpecting = true;
			
			context();
			
			_isExpecting = false;
		}
		
		private var _isExpecting:Boolean;
		
		mockolate_ingredient function get isExpecting():Boolean 
		{
			return _isExpecting;
		}
		
		/**
		 * @see mockolate#allow()
		 */
		public function allow(target:*):ExpectingCouverture
		{
			// calls to expect must happen after an invocation 
			// as the invocation type, and arguments are used
			// when adding the expectation.
			
			if (!_lastInvocation)
			{
				throw new MockolateError(["Unable to allow(), no Mockolate invocation has been recorded yet."], null, null);
			}
			
			var args:Array = _expectArgs || _lastInvocation.arguments;
			_expectArgs = null;

			var invocation:Invocation = _lastInvocation;
			_lastInvocation = null;
			
			return mockolateByTarget(invocation.target).expecter.allow(invocation, args);
		}
		
		/**
		 * @see mockolate#expect()
		 */
		public function expect(target:*):ExpectingCouverture
		{
			// calls to expect must happen after an invocation 
			// as the invocation type, and arguments are used
			// when adding the expectation.
			
			if (!_lastInvocation)
			{
				throw new MockolateError(["Unable to expect(), no Mockolate invocation has been recorded yet."], null, null);
			}
			
			var args:Array = _expectArgs || _lastInvocation.arguments;
			_expectArgs = null;

			var invocation:Invocation = _lastInvocation;
			_lastInvocation = null;
			
			return mockolateByTarget(invocation.target).expecter.expect(invocation, args);
		}
		
		private var _expectArgs:Array;
		
		/**
		 * @see mockolate#arg()
		 */
		public function expectArg(value:*):* 
		{
			_expectArgs ||= [];
			_expectArgs.push(value);
			
			return null;
		}

		/**
		 * Spy on a method, getter or setter.
		 */
		public function spy(target:*):Spy
		{
			// calls to spy must happen after an invocation 
			// as the invocation type, and arguments are used
			// when adding the expectation.
			
			if (!_lastInvocation)
			{
				throw new MockolateError(["Unable to spy(), no Mockolate invocation has been recorded yet."], null, null);
			}
			
			var args:Array = _expectArgs || _lastInvocation.arguments;
			_expectArgs = null;

			var invocation:Invocation = _lastInvocation;
			_lastInvocation = null;

			var mockolateInstance:Mockolate = mockolateByTarget(invocation.target);
			var spy:Spy = new Spy(mockolateInstance, invocation, args);

			mockolateInstance.addSpy(spy);
			
			return spy;
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
