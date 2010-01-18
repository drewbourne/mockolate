package mockolate.ingredients
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.getTimer;
    
    import mockolate.ingredients.answers.CallsWithInvocationAnswer;
    import mockolate.ingredients.faux.FauxInvocation;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.number.greaterThanOrEqualTo;
    import org.hamcrest.object.equalTo;
    
    use namespace mockolate_ingredient;
    
    public class MockingCouvertureTest
    {
        private var mockolate:Mockolate;
        private var mocker:MockingCouverture;
        private var invocation:Invocation;
        
        [Before]
        public function create():void
        {
            this.mockolate = new Mockolate();
            mocker = new MockingCouverture(mockolate);
            invocation = new FauxInvocation({ name: "example" })
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
            mocker.invoked(new FauxInvocation({ name: "example" }));
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
        public function method_once():void 
        {
        	mocker.method("example").once();
        	mocker.invoked(invocation);
        	mocker.verify();
        }
        
        [Test]
        public function method_twice():void 
        {
        	mocker.method("example").twice();
        	mocker.invoked(invocation);
        	mocker.verify();
        }
        
        [Test]
        public function method_thrice():void 
        {
        	mocker.method("example").twice();
        	mocker.invoked(invocation);
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
        public function method_never():void 
        {
        	mocker.method("example").never();
        	mocker.invoked(invocation);
        }    
   }
}