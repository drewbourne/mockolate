package mockolate.ingredients
{
    import asx.array.empty;
    import asx.array.filter;
    import asx.array.map;
    
    import flash.utils.getQualifiedClassName;
    
    import mockolate.errors.VerificationError;
    
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.collection.emptyArray;
    import org.hamcrest.number.greaterThanOrEqualTo;
    import org.hamcrest.number.lessThanOrEqualTo;
    import org.hamcrest.object.hasProperty;
    
    use namespace mockolate_ingredient;
    
    /**
     * Provides a Test Spy API.
     * 
     * @author drewbourne
     */
    public class VerifyingCouverture extends RecordingCouverture
    {
        private var _currentVerification:Verification;
        
        /**
         * Constructor.
         */
        public function VerifyingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
        }
        
        /**
         * Verifies if a method with the given name was invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).method("toString");
         * </listing>
         */
        public function method(name:String/*, ns:String=null*/):VerifyingCouverture
        {
            _currentVerification = new Verification();
            _currentVerification.invocationType = InvocationType.METHOD;
            _currentVerification.invocationTypeMatcher = hasProperty("invocationType", InvocationType.METHOD);
            _currentVerification.name = name;
            _currentVerification.nameMatcher = hasProperty("name", name);
                        
            doVerify();
            return this;
        }
        
        /**
         * Verifies if a property getter with the given name was invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).getter("toString");
         * </listing>
         */
        public function getter(name:String/*, ns:String=null*/):VerifyingCouverture
        {
            _currentVerification = new Verification();
            _currentVerification.invocationType = InvocationType.GETTER;
            _currentVerification.invocationTypeMatcher = hasProperty("invocationType", InvocationType.GETTER);
            _currentVerification.name = name;
            _currentVerification.nameMatcher = hasProperty("name", name);
            
            doVerify();
            return this;
        }        
        
        /**
         * Verifies if a property setter with the given name was invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).getter("toString");
         * </listing>
         */
        public function setter(name:String/*, ns:String=null*/):VerifyingCouverture
        {
            _currentVerification = new Verification();
            _currentVerification.invocationType = InvocationType.SETTER;
            _currentVerification.invocationTypeMatcher = hasProperty("invocationType", InvocationType.SETTER);
            _currentVerification.name = name;
            _currentVerification.nameMatcher = hasProperty("name", name);
            
            doVerify();
            return this;
        }

		/**
         * Verifies if a method or property was invoked with the given argument value. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).method("enabled").arg(true);
         * </listing>
         */        
        public function arg(value:Object):VerifyingCouverture
        {
        	return args(value);
        }
        
		/**
         * Verifies if a method or property was invoked with the given argument value. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").arg(true);
         * </listing>
         */         
        public function args(... rest):VerifyingCouverture
        {
        	// FIXME ensure there is a currentVerification
        	
            if (_currentVerification.invocationType == InvocationType.GETTER)
                throw new VerificationError(
                	"getters do not accept arguments", 
                	_currentVerification, mockolate, mockolate.target);
            
            _currentVerification.arguments = rest;
            _currentVerification.argumentsMatcher = hasProperty("arguments", array(map(rest, valueToMatcher)));
            
            doVerify();
            return this;
        }
        
        public function noArgs():VerifyingCouverture
        {
            if (_currentVerification.invocationType == InvocationType.GETTER)
                throw new VerificationError(
                	"getters do not accept arguments", 
                	_currentVerification, mockolate, mockolate.target);
            
            _currentVerification.arguments = null;
            _currentVerification.argumentsMatcher = hasProperty("arguments", emptyArray());
        	
        	doVerify();
        	return this;
        }
        
		/**
         * Verifies if a method or property was invoked the given number of times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").times(2);
         * </listing>
         */   
		public function times(n:int):VerifyingCouverture
        {
            _currentVerification.invokedCount = n.toString();
            _currentVerification.invokedCountMatcher = arrayWithSize(n);
            
            doVerify();
            return this;
        }
        
        /**
         * Verifies if a method or property was not invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").never();
         * </listing>
         */
        public function never():VerifyingCouverture
        {
            return times(0);
        }
        
        /**
         * Verifies if a method or property was invoked one time. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").once();
         * </listing>
         */ 
        public function once():VerifyingCouverture
        {
            return times(1);
        }
        
        /**
         * Verifies if a method or property was invoked two times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").twice();
         * </listing>
         */ 
        public function twice():VerifyingCouverture
        {
            return times(2);
        }
        
        // at the request of Brian LeGros we have thrice()
        /**
         * Verifies if a method or property was invoked three times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").thrice();
         * </listing>
         */ 
        public function thrice():VerifyingCouverture
        {
            return times(3);
        }
        
        /**
         * Verifies if a method or property was invoked at least the given number of times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").atLeast(2);
         * </listing>
         */
        public function atLeast(n:int):VerifyingCouverture
        {
            _currentVerification.invokedCount = "at least " + n;
            _currentVerification.invokedCountMatcher = arrayWithSize(greaterThanOrEqualTo(n));
            
            doVerify();
            return this;
        }
        
        /**
         * Verifies if a method or property was invoked at most the given number of times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").atMost(2);
         * </listing>
         */
        public function atMost(n:int):VerifyingCouverture
        {
            _currentVerification.invokedCount = "at most " + n;
            _currentVerification.invokedCountMatcher = arrayWithSize(lessThanOrEqualTo(n)); 
                  
            doVerify();
            return this;
        }
        
        // TODO sequenced(sequence:Sequence):VerifyingCouverture
        // TODO ordererd(group:String):VerifyingCouverture
        
        /**
         * @private
         */
        override mockolate_ingredient function verify():void
        {
        
        }
        
        /**
         * Verifies that the expected Invocations have been recorded. 
         * 
         * @private 
         */     
        protected function doVerify():void
        {
            var matchingInvocations:Array = invocations;
            var description:String = "";
			var failed:Boolean = false;
			
            if (_currentVerification.invocationTypeMatcher)
            {
                matchingInvocations = filter(matchingInvocations, _currentVerification.invocationTypeMatcher.matches);
				
				// do not fail when there are no invocations for the invocation type
				// as we want to include addition information in the error message
				// supplied by args() and invocation count methods: times() etc. 
            }

            if (_currentVerification.nameMatcher)
            {            
                matchingInvocations = filter(matchingInvocations, _currentVerification.nameMatcher.matches);
				
				// when there are no matching invocations
				// and the invocation type is getter
				// then fail at this point
				// as getters do not receive arguments.
				if (empty(matchingInvocations) && _currentVerification.invocationType.isGetter)
				{
					failed = true;
				}
            }
            
            if (_currentVerification.argumentsMatcher)
            {
                matchingInvocations = filter(matchingInvocations, _currentVerification.argumentsMatcher.matches);
				
				if (empty(matchingInvocations))
				{
					failed = true;		
				}
            }
            
            if (_currentVerification.invokedCountMatcher)
            {
                if (!_currentVerification.invokedCountMatcher.matches(matchingInvocations))
                {
					failed = true;
                }
            }
			
			if (failed)
			{
				var qname:String = getQualifiedClassName(this.mockolate.targetClass);
				
				description = qname.indexOf("::") != -1 ? qname.slice(qname.lastIndexOf('::') + 2) : qname;
				description += this.mockolate.name ? "(" + this.mockolate.name + ")" : ""
				description += '.';
				description += _currentVerification.name;
				
				if (_currentVerification.invocationType.isMethod)
				{
					description += "(";
					if (_currentVerification.arguments)
						description += _currentVerification.arguments.join(", ");
					description += ")";
				}
				else if (_currentVerification.invocationType.isGetter)
				{
					description += ";";
				}
				else if (_currentVerification.invocationType.isSetter)
				{
					if (_currentVerification.arguments)
					{
						description += " = ";
						description += _currentVerification.arguments.join(", ");
					}
					description += ";";
				}
				
				description += " invoked ";
				description += matchingInvocations.length;
				description += " times";
									
				fail(description);
			}
        }
        
        /**
         * @private 
         */
        protected function failIfEmpty(array:Array, description:String):void 
        {
            if (empty(array))
            {
                fail(description);
            } 
        }
        
        /**
         * @private 
         */
        protected function fail(description:String):void 
        {
            throw new VerificationError(
                description, _currentVerification, mockolate, mockolate.target);
        }
    }
}
