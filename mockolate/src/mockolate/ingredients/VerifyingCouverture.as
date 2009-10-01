package mockolate.ingredients
{
    import asx.array.empty;
    import asx.fn._;
    import asx.fn.partial;
    
    import mockolate.mistakes.VerifyFailedError;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.core.anyOf;
    import org.hamcrest.date.dateEqual;
    import org.hamcrest.number.greaterThan;
    import org.hamcrest.number.lessThan;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.hasProperties;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.text.re;
    
    use namespace mockolate_ingredient;
    
    /**
     * Verify as a Test Spy
     */
    public class VerifyingCouverture extends RecordingCouverture
    {
        private var _currentVerifier:Verifier;
        
        public function VerifyingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
        }
        
        public function method(name:String, ns:String=null):VerifyingCouverture
        {
            _currentVerifier = new Verifier();
            _currentVerifier.invocationType = InvocationType.METHOD;
            _currentVerifier.invocationTypeMatcher = hasProperty("invocationType", InvocationType.METHOD);
            _currentVerifier.name = name;
            _currentVerifier.nameMatcher = hasProperty("name", name);
                        
            doVerify();
            return this;
        }
        
        public function getter(name:String, ns:String=null):VerifyingCouverture
        {
            _currentVerifier = new Verifier();
            _currentVerifier.invocationType = InvocationType.GETTER;
            _currentVerifier.invocationTypeMatcher = hasProperty("invocationType", InvocationType.GETTER);
            _currentVerifier.name = name;
            _currentVerifier.nameMatcher = hasProperty("name", name);
            
            doVerify();
            return this;
        }        
        
        public function setter(name:String, ns:String=null):VerifyingCouverture
        {
            _currentVerifier = new Verifier();
            _currentVerifier.invocationType = InvocationType.SETTER;
            _currentVerifier.invocationTypeMatcher = hasProperty("invocationType", InvocationType.SETTER);
            _currentVerifier.name = name;
            _currentVerifier.nameMatcher = hasProperty("name", name);
            
            doVerify();
            return this;
        }
        
        public function args(... rest):VerifyingCouverture
        {
            if (_currentVerifier.invocationType == InvocationType.GETTER)
            {
                throw new VerifyFailedError("getters do not accept arguments", mockolate, mockolate.target);
            }
            
            _currentVerifier.arguments = rest;
            _currentVerifier.argumentsMatcher = hasProperty("arguments", array(rest.map(partial(valueToMatcher, _))));
            
            doVerify();
            return this;
        }
        
        public function times(n:int):VerifyingCouverture
        {
            _currentVerifier.invokedCount = n.toString();
            _currentVerifier.invokedCountMatcher = arrayWithSize(n);
            
            doVerify();
            return this;
        }
        
        public function never():VerifyingCouverture
        {
            return times(0);
        }
        
        public function once():VerifyingCouverture
        {
            return times(1);
        }
        
        public function twice():VerifyingCouverture
        {
            return times(2);
        }
        
        // at the behest of Brian LeGros we have thrice()
        public function thrice():VerifyingCouverture
        {
            return times(3);
        }
        
        public function atLeast(n:int):VerifyingCouverture
        {
            _currentVerifier.invokedCount = "at least " + n;
            _currentVerifier.invokedCountMatcher = arrayWithSize(greaterThan(n));
            
            doVerify();
            return this;
        }
        
        public function atMost(n:int):VerifyingCouverture
        {
            _currentVerifier.invokedCount = "at most " + n;
            _currentVerifier.invokedCountMatcher = arrayWithSize(lessThan(n)); 
                  
            doVerify();
            return this;
        }
        
        // TODO sequenced(sequence:Sequence):VerifyingCouverture
        // TODO ordererd(group:String):VerifyingCouverture
        
        /**
         *
         */
        override mockolate_ingredient function verify():void
        {
        
        }
        
        protected function valueToMatcher(value:*):Matcher
        {
            if (value is RegExp)
            {
                return anyOf(equalTo(value), re(value as RegExp));
            }
            
            if (value is Date)
            {
                return anyOf(equalTo(value), dateEqual(value));
            }
            
            if (value is Matcher)
            {
                return value as Matcher;
            }
            
            return equalTo(value);
        }
                
        protected function doVerify():void
        {
            var matchingInvocations:Array = invocations;
            
            if (_currentVerifier.invocationTypeMatcher)
            {
                matchingInvocations = matchingInvocations.filter(partial(_currentVerifier.invocationTypeMatcher.matches, _));
                failIfEmpty(matchingInvocations, "no invocations as " + _currentVerifier.invocationType);
            }

            if (_currentVerifier.nameMatcher)
            {            
                matchingInvocations = matchingInvocations.filter(partial(_currentVerifier.nameMatcher.matches, _));
                failIfEmpty(matchingInvocations, "no invocations with name " + _currentVerifier.name);
            }
            
            if (_currentVerifier.argumentsMatcher)
            {
                matchingInvocations = matchingInvocations.filter(partial(_currentVerifier.argumentsMatcher.matches, _));
                failIfEmpty(matchingInvocations, "no invocations with arguments " + _currentVerifier.arguments);
            }
            
            if (_currentVerifier.invokedCountMatcher)
            {
                if (!_currentVerifier.invokedCountMatcher.matches(matchingInvocations))
                {
                    fail("no invocations received " + _currentVerifier.invokedCount + " times ");
                }
            }
        }
        
        protected function failIfEmpty(array:Array, description:String):void 
        {
            if (empty(array))
            {
                fail(description);       
            } 
        }
        
        protected function fail(description:String):void 
        {
            throw new VerifyFailedError(description, mockolate, mockolate.target);    
        }
    }
}

import org.hamcrest.Matcher;
import org.hamcrest.core.allOf;
import mockolate.ingredients.InvocationType;

internal class Verifier
{
    public var invocationType:InvocationType;
    public var invocationTypeMatcher:Matcher;
    public var name:String;
    public var nameMatcher:Matcher;
    public var arguments:Array;
    public var argumentsMatcher:Matcher;
    public var invokedCount:String;
    public var invokedCountMatcher:Matcher;
    
    public function Verifier()
    {
    }
}