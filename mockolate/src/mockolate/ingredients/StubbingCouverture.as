package mockolate.ingredients
{    
    import asx.array.detect;
    import asx.fn._;
    import asx.fn.partial;
    
    import flash.events.Event;
    
    import mockolate.errors.StubMissingError;
    import mockolate.ingredients.answers.Answer;
    import mockolate.ingredients.answers.CallsAnswer;
    import mockolate.ingredients.answers.DispatchesEventAnswer;
    import mockolate.ingredients.answers.ReturnsAnswer;
    import mockolate.ingredients.answers.ThrowsAnswer;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.core.anyOf;
    import org.hamcrest.date.dateEqual;
    import org.hamcrest.number.greaterThan;
    import org.hamcrest.number.lessThan;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.text.re;
    
    use namespace mockolate_ingredient;
    
    /**
     * Stub behaviour of the target, such as:
     * <ul>
     * <li>return values, </li>
     * <li>calling functions, </li>
     * <li>dispatching events, </li>
     * <li>throwing errors. </li>
     * </ul>
     */
    public class StubbingCouverture extends Couverture
    {
        private var _expectations:Array;
        private var _propertyExpectations:Array
        private var _methodExpectations:Array;
        
        private var _currentExpectation:StubExpectation;
        
        public function StubbingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
            
            _expectations = [];
            _propertyExpectations = [];
            _methodExpectations = [];
        }
        
        // FIXME should return a MethodStubbingCouverture that hides method() and property()
        public function method(name:String, ns:String=null):StubbingCouverture
        {
            // FIXME this _really_ should check that the method actually exists on the Class we are mocking 
            
            createMethodStub(name, ns);
            return this;
        }
        
        // Should return a PropertyStubbingCouverture that hides method() and property() and provides only arg() not args()
        public function property(name:String, ns:String=null):StubbingCouverture
        {
            // FIXME this _really_ should check that the property actually exists on the Class we are mocking
            
            createPropertyStub(name, ns);
            return this;
        }
        
        public function args(... rest):StubbingCouverture
        {
            // FIXME this _really_ should check that the method or property accepts the number of matchers given.
            // we can ignore the types of the matchers though, it will fail when run if given incorrect values.
            
            setArgs(rest);
            return this;
        }
        
        public function noArgs():StubbingCouverture
        {
            // FIXME this _really_ should check that the method or property accepts no arguments.
            
            setNoArgs();
            return this;
        }
        
        public function returns(value:*):StubbingCouverture
        {
            addReturns(value);
            return this;
        }
        
        public function throws(error:Error):StubbingCouverture
        {
            addThrows(error);
            return this;
        }
        
        public function calls(fn:Function, args:Array=null):StubbingCouverture
        {
            addCalls(fn, args);
            return this;
        }
        
        public function dispatches(event:Event, delay:Number=0):StubbingCouverture
        {
            addDispatches(event, delay);
            return this;
        }
        
//        public function times(n:int):StubbingCouverture
//        {
//            setReceiveCount(equalTo(n));
//            return this;
//        }
//        
//        public function never():StubbingCouverture
//        {
//            return times(0);
//        }
//        
//        public function once():StubbingCouverture
//        {
//            return times(1);
//        }
//        
//        public function twice():StubbingCouverture
//        {
//            return times(2);
//        }
//        
//        // at the request of Brian LeGros we have thrice()
//        public function thrice():StubbingCouverture
//        {
//            return times(3);
//        }
//        
//        public function atLeast(n:int):StubbingCouverture
//        {
//            setReceiveCount(greaterThan(n));
//            return this;
//        }
//        
//        public function atMost(n:int):StubbingCouverture
//        {
//            setReceiveCount(lessThan(n));
//            return this;
//        }
        
        public function ordered(group:String=null):StubbingCouverture
        {
            return this;
        }
        
        mockolate_ingredient function get expectations():Array
        {
            return _expectations.slice(0);
        }
        
        /**
         *
         */
        override mockolate_ingredient function invoked(invocation:Invocation):void
        {
            // proceed with return value if matches a specified stub
            // else if nice return a false-y value
            // else if strict throw an UnexpectedBehaviourError
            
            var invokedAs:Object = {};
            invokedAs[ InvocationType.METHOD ] = invokedAsMethod;
            invokedAs[ InvocationType.GETTER ] = invokedAsGetter;
            invokedAs[ InvocationType.SETTER ] = invokedAsSetter;
            invokedAs[ invocation.invocationType ](invocation);
        }
        
        protected function invokedAsMethod(invocation:Invocation):void
        {
            // find the first matching expectation
            // TODO find the first "eligible" matching expectation
            // FIXME rather ugly
            
            var foundAndInvoked:Boolean = false;
            
            for each (var expectation:StubExpectation in _methodExpectations)
            {
                // FIXME check that the argsMatcher actually exists
                if (expectation.name == invocation.name
                    && expectation.argsMatcher.matches(invocation.arguments))
                {
                    // it is possible that one of the Answers will throw an error
                    var results:Array = expectation.answers.map(function(answer:Answer, i:int, a:Array):* {
                        return answer.invoke();
                    });
                    
                    // use the first result that is not undefined, else undefined.
                    invocation.returnValue = detect(results, function(value:*, i:int, a:Array):Boolean {
                        return value !== undefined;
                    });
                    
                    foundAndInvoked = true;
                    break;
                }
            }
            
            // FIXME rather ugly
            if (!foundAndInvoked && this.mockolate.isStrict)
            {
                throw new StubMissingError(this.mockolate, this.mockolate.target, invocation);   
            }
        }
        
        protected function invokedAsGetter(invocation:Invocation):void
        {
            // find the first matching expectation
            // TODO find the first "eligible" matching expectation
            // FIXME rather ugly
            
            var foundAndInvoked:Boolean = false;
            
            for each (var expectation:StubExpectation in _propertyExpectations)
            {
                // getters do not receive args so we dont need to check the argsMatcher here
                if (expectation.name == invocation.name)
                {
                    var results:Array = expectation.answers.map(function(answer:Answer, i:int, a:Array):* {
                        return answer.invoke();
                    });
                    
                    // use the first result that is not undefined, else undefined.
                    invocation.returnValue = detect(results, function(value:*, i:int, a:Array):Boolean {
                        return value !== undefined;
                    });
                    
                    foundAndInvoked = true;
                    break;
                }
            }
            
            // FIXME rather ugly
            if (!foundAndInvoked && this.mockolate.isStrict)
            {
                throw new StubMissingError(this.mockolate, this.mockolate.target, invocation);   
            }
        }
        
        protected function invokedAsSetter(invocation:Invocation):void 
        {
            // find the first matching expectation
            // TODO find the first "eligible" matching expectation
            
             var foundAndInvoked:Boolean = false;
            
            for each (var expectation:StubExpectation in _propertyExpectations)
            {
                // FIXME check that the argsMatcher actually exists                
                if (expectation.name == invocation.name
                    && expectation.argsMatcher.matches(invocation.arguments))
                {
                    var results:Array = expectation.answers.map(function(answer:Answer, i:int, a:Array):* {
                        return answer.invoke();
                    });
                    
                    // use the first result that is not undefined, else undefined.
                    invocation.returnValue = detect(results, function(value:*, i:int, a:Array):Boolean {
                        return value !== undefined;
                    });
                    
                    foundAndInvoked = true;
                    break;
                }
            }
            
            // FIXME rather ugly
            if (!foundAndInvoked && this.mockolate.isStrict)
            {
                throw new StubMissingError(this.mockolate, this.mockolate.target, invocation);   
            }
        }
        
        protected function createStub(name:String, ns:String=null):StubExpectation
        {
            var expectation:StubExpectation = new StubExpectation();
            expectation.name = name;
//            expectation.namespace = ns;
            return expectation;
        }
        
        protected function createPropertyStub(name:String, ns:String=null):void
        {
            _currentExpectation = createStub(name, ns);
            _expectations.push(_currentExpectation);
            _propertyExpectations.push(_currentExpectation);
        }        
        
        protected function createMethodStub(name:String, ns:String=null):void
        {
            _currentExpectation = createStub(name, ns);
            _expectations.push(_currentExpectation);            
            _methodExpectations.push(_currentExpectation);
        }
        
        protected function setArgs(args:Array):void
        {          
            trace('Stubber args', args);  
            trace('Stubber expe', _currentExpectation);
            _currentExpectation.argsMatcher = array(args.map(partial(valueToMatcher, _)));
        }
        
        protected function setNoArgs():void
        {
            _currentExpectation.argsMatcher = nullValue();
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
        
//        protected function setReceiveCount(matcher:Matcher):void
//        {
//            _currentExpectation.invokeCountMatcher = matcher;
//        }
        
        protected function addAnswer(answer:Answer):void
        {
            _currentExpectation.addAnswer(answer);
        }
        
        protected function addThrows(error:Error):void
        {
            addAnswer(new ThrowsAnswer(error));
        }
        
        protected function addDispatches(event:Event, delay:Number=0):void
        {
            addAnswer(new DispatchesEventAnswer(null, event, delay));
        }
        
        protected function addCalls(fn:Function, args:Array=null):void
        {
            addAnswer(new CallsAnswer(fn, args));
        }
        
        protected function addReturns(value:*):void
        {
            addAnswer(new ReturnsAnswer([ value ]));
        }
        
        /**
         *
         */
        override mockolate_ingredient function verify():void
        {
        
        }        
    }
}

import org.hamcrest.Matcher;
import flash.events.IEventDispatcher;
import flash.events.Event;
import flash.utils.setTimeout;
import asx.number.bound;
import mockolate.ingredients.answers.Answer;
import mockolate.ingredients.InvocationType;

/**
 *
 */
internal class StubExpectation
{
    public var name:String;
    public var namespace:String;
    public var argsMatcher:Matcher;
    public var invokeCountMatcher:Matcher;
    [ArrayElementType("mockolate.ingredients.StubbingCouverture$::Answer")]
    public var answers:Array;
    public var orderGroup:String;
    public var orderIndex:int;
    public var invokedCount:int;
    
    public function StubExpectation():void
    {
        answers = [];
    }
    
    public function addAnswer(answer:Answer):void
    {
        answers.push(answer);
    }
}
