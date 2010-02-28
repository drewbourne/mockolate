package mockolate.ingredients
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.getTimer;
    
    import mockolate.ingredients.answers.CallsAnswer;
    import mockolate.ingredients.answers.ThrowsAnswer;
    import mockolate.ingredients.faux.FauxInvocation;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.collection.array;
    import org.hamcrest.number.greaterThanOrEqualTo;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.isTrue;
    
    use namespace mockolate_ingredient;
    
    public class MockingCouvertureTest
    {
        private var mockolate:Mockolate;
        private var mocker:MockingCouverture;
        private var target:IEventDispatcher;
        
        [Before]
        public function create():void
        {
            target = new EventDispatcher();
            
            this.mockolate = new Mockolate();
            this.mockolate.target = target;
            
            mocker = new MockingCouverture(mockolate);
            invocation = new FauxInvocation({ name: "example" })
        }
        
        public function invoke(options:Object):Invocation 
        {
            var invocation:Invocation = new FauxInvocation(options);
            mocker.invoked(invocation);
            return invocation;
        }
        
        public function invocation(options:Object):Invocation
        {
            return new FauxInvocation(options);
        }
        
        // method, no args, no return
        [Test(expected="mockolate.errors.ExpectationError")]
        public function mockMethodShouldFailIfNotInvoked():void
        {
            mocker.method("example");
            mocker.verify();
        }
        
        [Test]
        public function mockMethodShouldPassIfInvoked():void
        {
            mocker.method("example");
            invoke({ name: "example" });
            mocker.verify();
        }
        
        //
        //	methods
        //
        
        //
        //	properties
        //
        
        //
        //	args
        //
        
        //
        //	answers
        //
        
        // 	returns
                
        [Test]
        public function method_returns():void 
        {
        	mocker.method("example").returns(42);
        	mocker.invoked(invocation);
        	assertThat(invocation.returnValue, equalTo(42));
        }
        
        [Test]
        public function method_returns_sequence():void 
        {
        	mocker.method("example").returns(1, 3, 5);
        	// should return each value in the sequence
        	mocker.invoked(invocation);
        	assertThat(invocation.returnValue, equalTo(1));
        	mocker.invoked(invocation);
        	assertThat(invocation.returnValue, equalTo(3));
        	mocker.invoked(invocation);
        	assertThat(invocation.returnValue, equalTo(5));
        	// should repeat last sequence value
        	mocker.invoked(invocation);
        	assertThat(invocation.returnValue, equalTo(5));
        }
        
        //	calls
        
        [Test]
        public function method_calls():void 
        {
        	var called:Boolean = false;
        	var callee:Function = function():void { called = true; }
        	
        	mocker.method("example").calls(callee);
        	mocker.invoked(invocation);
        	assertThat(called, equalTo(true));
        }
        
        [Test]
        public function method_calls_withArgs():void 
        {
        	var result:int;
        	var called:Boolean = false;
        	var callee:Function = function(a:int, b:int):void { result = a + b; }
        	
        	mocker.method("example").calls(callee, [1, 2]);
        	mocker.invoked(invocation);
        	assertThat(result, equalTo(3));
        }
        
        //	dispatches
        
        [Test(async, timeout=1000)]
        public function method_dispatches():void 
        {
			this.mockolate.target = new EventDispatcher();
			(this.mockolate.target as IEventDispatcher).addEventListener(Event.COMPLETE, function(event:Event):void {
				trace('method_dispatches', event.target);
			});
			      	
        	Async.proceedOnEvent(this, this.mockolate.target, Event.COMPLETE);
        	mocker.method("example").dispatches(new Event(Event.COMPLETE));
        	mocker.invoked(invocation);
        }
        
        [Test(expected="mockolate.errors.ExpectationError")]
        public function method_dispatches_complainsWhenTargetIsNotIEventDispatcher():void 
        {
        	this.mockolate.target = { example: function():void {} };         	
        	Async.proceedOnEvent(this, this.mockolate.target, Event.COMPLETE);
        	mocker.method("example").dispatches(new Event(Event.COMPLETE));
        }
        
        [Test(async, timeout=1000)]
        public function method_dispatches_withDelay():void 
        {
        	var start:int = getTimer();
        	var assert:Function = function(event:Event, data:Object=null):void {
        		assertThat(getTimer() - start, greaterThanOrEqualTo(300));
        	};
        	
        	this.mockolate.target = new EventDispatcher();      	
        	Async.handleEvent(this, this.mockolate.target, Event.COMPLETE, assert, 500);
        	mocker.method("example").dispatches(new Event(Event.COMPLETE), 300);
        	mocker.invoked(invocation);
        }
        
        // 	throws
        
        [Test(expected="Error")]
        public function method_throws():void 
        {
        	mocker.method("example").throws(new Error("Oh No!"));
        	mocker.invoked(invocation);
        }
        
        // proceeds
        
        [Test]
        public function method_proceeds():void
        {
//        	mocker.method("example").proceeds();
//        	mocker.invoked(invocation);
        }
        
        // 	answers
        
        [Test]
        public function method_answers():void 
        {
        	var called:Invocation = null;
        	var callee:Function = function(value:Invocation):void { called = value; }
        	
        	mocker.method("example").answers(new CallsWithInvocationAnswer(callee));
        	mocker.invoked(invocation);        	
        }
        
        //
        //	invoke counts
        //
        
        [Test]
        public function once_shouldPassIfInvokedOnce():void 
        {
        	mocker.method("example").once();
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.ExpectationError")]
        public function once_shouldFailIfInvokedLessThanOnce():void 
        {
        	mocker.method("example").once();
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function once_shouldFailIfInvokedMoreThanOnce():void 
        {
        	mocker.method("example").once();
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test]
        public function twice_shouldPassIfInvokedTwice():void 
        {
        	mocker.method("example").twice();
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.ExpectationError")]
        public function twice_shouldFailIfInvokedLessThanTwice():void 
        {
        	mocker.method("example").twice();
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function twice_shouldFailIfInvokedMoreThanTwice():void 
        {
        	mocker.method("example").twice();
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test]
        public function thrice_shouldPassIfInvokedThreeTimes():void 
        {
        	mocker.method("example").thrice();
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.ExpectationError")]
        public function thrice_shouldFailIfInvokedLessThanThreeTimes():void 
        {
        	mocker.method("example").thrice();
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function thrice_shouldFailIfInvokedMoreThanThreeTimes():void 
        {
        	mocker.method("example").thrice();
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	invoke({ name: "example" });
        	mocker.verify();
        }

        [Test]
        public function method_times():void 
        {
        	mocker.method("example").once();
        	mocker.invoked(invocation);
        	mocker.verify();
        }
       
        [Test(expected="mockolate.errors.InvocationError")]
        public function never():void 
        {
        	mocker.method("example").never();
        	invoke({ name: "example" });
        }
        
        [Test]
        public function noArgs_shouldPassIfInvokedWithNoArguments():void 
        {
            mocker.method("example").noArgs();
            invoke({ name: "example" });
            invoke({ name: "example", arguments: null });
            invoke({ name: "example", arguments: [] });
            mocker.verify();
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function noArgs_shouldFailIfInvokedWithArguments():void 
        {
            mocker.method("example").noArgs();
            invoke({ name: "example", arguments: [ 1 ] });
            mocker.verify();            
        }
        
        [Test]
        public function args_shouldPassIfInvokedWithMatchingArguments():void 
        {
            mocker.method("example").args(1, 2, 3);
            invoke({ name: "example", arguments: [ 1, 2, 3 ] });
            mocker.verify();
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function args_shouldFailIfInvokedWithoutMatchingArguments():void 
        {
            mocker.method("example").args(1, 2, 3);
            invoke({ name: "example", arguments: [ 1, 2 ] });
            mocker.verify();
        }
    
        [Test]
        public function return_shouldReturnValue():void 
        {
            mocker.method("example").returns(42);
            assertThat(invoke({ name: "example" }), hasProperty("returnValue", 42));
            mocker.verify();
        }
        
        [Test]
        public function return_shouldFirstDefinedReturnValue():void 
        {
            mocker.method("example").returns(42).returns(43);
            assertThat(invoke({ name: "example" }), hasProperty("returnValue", 42));
            mocker.verify();
        }
        
        [Test(expected="Error")]
        public function throws_shouldThrowError():void 
        {
            mocker.method("example").throws(new Error("Oh no!"));
            invoke({ name: "example" });
        }
        
        [Test]
        public function calls_shouldCallFunction():void 
        {
            var called:Boolean = false;
            
            function callClosure():void 
            {
                called = true;
            }
            
            mocker.method("example").calls(callClosure);
            invoke({ name: "example" });
            
            assertThat(called, isTrue());
            mocker.verify();
        }
        
        [Test]
        public function calls_withArgs_shouldCallFunctionWithArgs():void 
        {
            var calledArguments:Array = null;
            
            function callClosure(...rest):void 
            {
                calledArguments = rest;
            }
            
            mocker.method("example").calls(callClosure, [1, 2, 3]);
            invoke({ name: "example" });
            
            assertThat(calledArguments, array(1, 2, 3));
            
            mocker.verify();
        }
        
        [Test(async)]
        public function dispatches_shouldDispatchEvent():void 
        {
            // disable strict checking to enable implicit EventDispatcher behaviour
            this.mockolate.isStrict = false;
            
            // unfortunately convoluted to work around proxy & flexunit
            var dispatcher:IEventDispatcher = new EventDispatcher();
            
            function listener():void 
            {
                dispatcher.dispatchEvent(new Event("dispatches_shouldDispatchEvent"));        
            }
            
            Async.proceedOnEvent(this, dispatcher, "dispatches_shouldDispatchEvent");

            // the tested expectation 
            mocker.method("example").dispatches(new Event(Event.COMPLETE));
            
            // invoke addEventListener, forwards arguments an actual EventDispatcher instance
            // which is where the dispatchEvent will come from.
            invoke({ name: "addEventListener", arguments: [Event.COMPLETE, listener] });
            
            // invoke the expectation
            invoke({ name: "example" });
            
            mocker.verify();
        }
        
        [Test(async)]
        public function dispatches_withDelay_shouldDispatchEventAfterDelay():void 
        {
            // disable strict checking to enable implicit EventDispatcher behaviour
            this.mockolate.isStrict = false;
            
            // measure delay
            var delay:int = 0;
            var start:int = getTimer();
            
            // unfortunately convoluted to work around proxy & flexunit
            var dispatcher:IEventDispatcher = new EventDispatcher();
            
            function listener():void 
            {
                delay = getTimer() - start;
                dispatcher.dispatchEvent(new Event("dispatches_shouldDispatchEvent"));        
            }
            
            Async.handleEvent(this, dispatcher, "dispatches_shouldDispatchEvent", function():void {
                assertThat(delay, greaterThanOrEqualTo(300));
            });

            // the tested expectation 
            mocker.method("example").dispatches(new Event(Event.COMPLETE), 300);
            
            // invoke addEventListener, forwards arguments an actual EventDispatcher instance
            // which is where the dispatchEvent will come from.
            invoke({ name: "addEventListener", arguments: [Event.COMPLETE, listener] });
            
            // invoke the expectation
            invoke({ name: "example" });
            
            mocker.verify();
        }
        
        [Test(async)]
        public function asEventDispatcher_enablesNiceEventDispatcherExpectations():void 
        {
            // as strict so we get errors for undefined expectations
            this.mockolate.isStrict = true;
            
            // unfortunately convoluted to work around proxy & flexunit
            var dispatcher:IEventDispatcher = new EventDispatcher();
            
            function listener():void 
            {
                dispatcher.dispatchEvent(new Event("dispatches_shouldDispatchEvent"));        
            }
            
            Async.proceedOnEvent(this, dispatcher, "dispatches_shouldDispatchEvent");

            // stub EventDispatcher methods
            mocker.asEventDispatcher();

            // the tested expectation 
            mocker.method("example").dispatches(new Event(Event.COMPLETE));
            
            // invoke addEventListener, forwards arguments an actual EventDispatcher instance
            // which is where the dispatchEvent will come from.
            invoke({ name: "addEventListener", arguments: [Event.COMPLETE, listener] });
            
            // invoke the expectation
            invoke({ name: "example" });
            
            mocker.verify();
        }
        
        [Test(async)]
        public function pass_shouldProceedWithOriginalImplementation():void 
        {
            // target is an actual EventDispatcher instance
            // so we should be able to listen for events directly
            // and pass should forward the invocation to the target
            // thus dispatching the event 
            
            Async.proceedOnEvent(this, target, Event.COMPLETE);
            
            mocker.method("dispatchEvent").anyArgs().pass();
            
            invoke({ target: target, name: "dispatchEvent", arguments: [new Event(Event.COMPLETE)] });
            
            mocker.verify();
        }
        
        [Test(expected="Error")]
        public function answers_callsAnswerInvokeWithInvocation():void 
        {
            mocker.method("example").answers(new ThrowsAnswer(new Error("thrown by ThrowsAnswer")));
            invoke({ name: "example" });
        }
    }
}