package mockolate.ingredients
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import mockolate.decorations.EventDispatcherDecorator;
	import mockolate.errors.ExpectationError;
	import mockolate.ingredients.answers.CallsAnswer;
	import mockolate.ingredients.answers.CallsWithInvocationAnswer;
	import mockolate.ingredients.answers.ThrowsAnswer;
	import mockolate.ingredients.faux.FauxInvocation;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.anything;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	
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
			
			this.mockolate = new Mockolate("Example");
			this.mockolate.target = target;
			this.mockolate.targetClass = EventDispatcher;
			
			mocker = new MockingCouverture(mockolate);
			
			this.mockolate.mocker = mocker;
		}
		
		public function invoke(options:Object):Invocation 
		{
			var invocation:Invocation = new FauxInvocation(options);
			mocker.invoked(invocation);
			return invocation;
		}
		
		//
		//
		//
		
		public function niceMockolateWithMockMethodShouldDefaultToAtLeastOneInvocationCount():void 
		{
			mocker.mock().method("example");
			invoke({ name: "example" });			
			mocker.verify();
		}
		
		public function niceMockolateWithMockMethodShouldAllowNeverInvocationCount():void 
		{
			mocker.mock().method("example").never();
			mocker.verify();
		}
		
		//
		//	method
		//
		
		// method, no args, no return
		[Test(expected="mockolate.errors.ExpectationError")]
		public function method_shouldFailIfNotInvoked():void
		{
			mocker.method("example");
			mocker.verify();
		}
		
		[Test]
		public function method_shouldFailIfNotInvokedWithANiceMessage():void
		{
			mocker.method("example");
			
			try
			{
				mocker.verify();
			}
			catch (error:ExpectationError)
			{
				assertThat(error.message, equalTo("1 unmet Expectation\n\tflash.events::EventDispatcher<\"Example\">#example()"));
			}
		}
		
		[Test]
		public function method_shouldPassIfInvoked():void
		{
			mocker.method("example");
			invoke({ name: "example" });
			mocker.verify();
		}
		
		//
		//	method(s) by RegExp 
		//
		
		[Test(expected="mockolate.errors.ExpectationError")]
		public function methods_byRegExp_shouldFailIfNotInvoked():void 
		{
			mocker.methods(/^do/);
			mocker.verify();
		}
		
		[Test]
		public function methods_byRegExp_shouldFailWithANiceMessage():void 
		{
			mocker.methods(/^do/);
			
			try
			{
				mocker.verify();
			}
			catch (error:ExpectationError)
			{
				assertThat(error.message, equalTo("1 unmet Expectation\n\tflash.events::EventDispatcher<\"Example\">#/^do/()"));
			}
		}
		
		[Test]
		public function methods_byRegExp_shouldPassIfMethodWithMatchingNameInvoked():void 
		{
			mocker.methods(/^do/);
			invoke({ name: "doPass" });
			mocker.verify();
		}
		
		//
		//	property
		//
		
		[Test]
		public function property_getter_shouldPassIfInvoked():void 
		{
			mocker.property("example").noArgs();
			invoke({ name: "example", invocationType: InvocationType.GETTER });
			mocker.verify();
		}
		
		//
		//	getter
		//
		
		[Test]
		public function getter_shouldPassIfInvoked():void 
		{
			mocker.getter("example");
			invoke({ name: "example", invocationType: InvocationType.GETTER });
			mocker.verify();
		}
		
		[Test(expected="mockolate.errors.ExpectationError")]
		public function getter_shouldFailIfNotInvoked():void 
		{
			mocker.getter("example");
			mocker.verify();
		}
		
		[Test]
		public function getter_shouldFailWithNiceMessage():void 
		{
			mocker.getter("example");
			
			try
			{
				mocker.verify();
			}
			catch (error:ExpectationError)
			{
				assertThat(error.message, equalTo("1 unmet Expectation\n\tflash.events::EventDispatcher<\"Example\">#example"));	
			}
		}
		
		//
		//	getters by RegExp
		//
		
		[Test]
		public function getters_shouldPassIfInvoked():void 
		{
			mocker.getters(/^example/);
			invoke({ name: "exampleGetter", invocationType: InvocationType.GETTER });
			mocker.verify();
		}
		
		[Test(expected="mockolate.errors.ExpectationError")]
		public function getters_shouldFailIfNotInvoked():void 
		{
			mocker.getters(/^example/);
			mocker.verify();
		}
		
		[Test]
		public function getters_shouldFailWithNiceMessage():void 
		{
			mocker.getters(/^example/);
			
			try
			{
				mocker.verify();
			}
			catch (error:ExpectationError)
			{
				assertThat(error.message, equalTo("1 unmet Expectation\n\tflash.events::EventDispatcher<\"Example\">#/^example/"));
			}
		}	
		
		//
		//	setter
		//
		
		[Test]
		public function setter_shouldPassIfInvoked():void 
		{
			mocker.setter("example").arg(true);
			invoke({ name: "example", invocationType: InvocationType.SETTER, arguments: [true] });
			mocker.verify();
		}
		
		[Test(expected="mockolate.errors.ExpectationError")]
		public function setter_shouldFailIfNotInvoked():void 
		{
			mocker.setter("example").arg(true);
			mocker.verify();
		}
		
		[Test]
		public function setter_shouldFailWithNiceMessage():void 
		{
			mocker.setter("example").arg(true);
			
			try
			{
				mocker.verify();
			}
			catch (error:ExpectationError)
			{
				assertThat(error.message, equalTo("1 unmet Expectation\n\tflash.events::EventDispatcher<\"Example\">#example = <true>"));
			}
		}
		
		//
		//	setters by RegExp
		//
		
		[Test]
		public function setters_shouldPassIfInvoked():void 
		{
			mocker.setters(/^example/).arg(true);
			invoke({ name: "exampleSetter", invocationType: InvocationType.SETTER, arguments: [true] });
			mocker.verify();
		}
		
		[Test(expected="mockolate.errors.ExpectationError")]
		public function setters_shouldFailIfNotInvoked():void 
		{
			mocker.setters(/^example/).arg(true);
			mocker.verify();
		}
		
		[Test]
		public function setters_shouldFailWithNiceMessage():void 
		{
			mocker.setters(/^example/).arg(true);
			
			try
			{
				mocker.verify();
			}
			catch (error:ExpectationError)
			{
				assertThat(error.message, equalTo("1 unmet Expectation\n\tflash.events::EventDispatcher<\"Example\">#/^example/ = <true>"));
			}
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
		
		[Test(expected="mockolate.errors.InvocationError")]
		public function never():void 
		{
			mocker.method("example").never();
			invoke({ name: "example" });
		}
		
		//
		//    args
		//
		
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
		public function args_shouldUseArrayAsIs():void 
		{
			mocker.method("example").args([1, 2, 3]);
			invoke({ name: "example", arguments: [ [1, 2, 3] ] });
			mocker.verify();
		}
		
		//
		//    returns
		//
		
		[Test]
		public function return_shouldReturnValue():void 
		{
			mocker.method("example").returns(42);
			assertThat(invoke({ name: "example" }), hasProperty("returnValue", 42));
			mocker.verify();
		}

		// disabled due to syntax improvements no longer allowing multiple calls to returns()
//		[Test]
//		public function return_shouldFirstDefinedReturnValue():void 
//		{
//			mocker.method("example").returns(42).returns(43);
//			assertThat(invoke({ name: "example" }), hasProperty("returnValue", 42));
//			mocker.verify();
//		}
		
		[Test]
		public function returns_sequence():void 
		{
			var invocation:Invocation;
			
			mocker.method("example").returns(1, 3, 5);
			// should return each value in the sequence
			invocation = invoke({ name: "example" });
			assertThat(invocation.returnValue, equalTo(1));
			invocation = invoke({ name: "example" });
			assertThat(invocation.returnValue, equalTo(3));
			invocation = invoke({ name: "example" });
			assertThat(invocation.returnValue, equalTo(5));
			// should repeat last sequence value
			invocation = invoke({ name: "example" });
			assertThat(invocation.returnValue, equalTo(5));
		}
		
		//
		//    throws
		//
		
		[Test(expected="Error")]
		public function throws_shouldThrowError():void 
		{
			mocker.method("example").throws(new Error("Oh no!"));
			invoke({ name: "example" });
		}
		
		//
		//    calls
		//
		
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
		
		//
		//    dispatches
		//
		
		[Test(async)]
		public function dispatches_shouldDispatchEvent():void 
		{
			// disable strict checking to enable implicit EventDispatcher behaviour
			this.mockolate.mockType = MockType.NICE;
			
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
			invoke({ target: target, name: "addEventListener", arguments: [Event.COMPLETE, listener] });
			
			// invoke the expectation
			invoke({ target: target, name: "example" });
			
			mocker.verify();
		}
		
		[Test(async)]
		public function dispatches_withDelay_shouldDispatchEventAfterDelay():void 
		{
			// disable strict checking to enable implicit EventDispatcher behaviour
			this.mockolate.mockType = MockType.NICE;
			
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
			invoke({ target: target, name: "addEventListener", arguments: [Event.COMPLETE, listener] });
			
			// invoke the expectation
			invoke({ target: target, name: "example" });
			
			mocker.verify();
		}
		
		[Test(async)]
		public function asEventDispatcher_enablesNiceEventDispatcherExpectations():void 
		{
			// as strict so we get errors for undefined expectations
			this.mockolate.mockType = MockType.STRICT;
			
			// unfortunately convoluted to work around proxy & flexunit
			var dispatcher:IEventDispatcher = new EventDispatcher();
			
			function listener():void 
			{
				dispatcher.dispatchEvent(new Event("dispatches_shouldDispatchEvent"));        
			}
			
			Async.proceedOnEvent(this, dispatcher, "dispatches_shouldDispatchEvent");
			
			// stub EventDispatcher methods
			mocker.stub().asEventDispatcher();
			
			// the tested expectation 
			mocker.method("example").dispatches(new Event(Event.COMPLETE));
			
			// invoke addEventListener, forwards arguments an actual EventDispatcher instance
			// which is where the dispatchEvent will come from.
			invoke({ target: target, name: "addEventListener", arguments: [Event.COMPLETE, listener] });
			
			// invoke the expectation
			invoke({ target: target, name: "example" });
			
			mocker.verify();
		}
		
		[Test]
		public function eventDispatcher_shouldAllowMockingOfEventDispatcherMethods():void 
		{
			mocker.method('addEventListener').args('change', Function, anything(), anything(), anything());
			
			invoke({ target: target, name: 'addEventListener', arguments: ['change', function():void {}, false, 0, true] })
			
			mocker.verify();
		}
		
		[Test]
		public function asEventDispatcher_calledMultipleTimes_shouldOnlyCreateOneDecorator():void 
		{
			var eventDispatcherDecorator1:EventDispatcherDecorator = mocker.asEventDispatcher();
			var eventDispatcherDecorator2:EventDispatcherDecorator = mocker.asEventDispatcher();
			
			assertThat(eventDispatcherDecorator1, equalTo(eventDispatcherDecorator2));
		}
				
		//
		//    callsSuper
		//
		
		[Test(async)]
		public function callsSuper_shouldProceedWithOriginalImplementation():void 
		{
			// target is an actual EventDispatcher instance
			// so we should be able to listen for events directly
			// and pass should forward the invocation to the target
			// thus dispatching the event 
			
			Async.proceedOnEvent(this, target, Event.COMPLETE);
			
			mocker.method("dispatchEvent").anyArgs().callsSuper();
			
			invoke({ target: target, name: "dispatchEvent", arguments: [new Event(Event.COMPLETE)] });
			
			mocker.verify();
		}
		
		[Test(async)]
		public function pass_shouldBeAnAliasOfCallsSuper():void 
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
		
		//
		//    answers
		//
		
		[Test(expected="Error")]
		public function answers_callsAnswerInvokeWithInvocation():void 
		{
			mocker.method("example").answers(new ThrowsAnswer(new Error("thrown by ThrowsAnswer")));
			invoke({ name: "example" });
		}
		
		//
		//    callsWithInvocation
		//
		
		[Test]
		public function callsWithInvocation_shouldCallFunctionWithInvocation():void 
		{
			var receivedInvocation:Invocation;
			
			function callClosure(invocation:Invocation):void 
			{
				receivedInvocation = invocation;
			}
			
			mocker.method("example").callsWithInvocation(callClosure);
			invoke({ name: "example" });
			
			assertThat(receivedInvocation, hasProperties({ name: "example" }));
			mocker.verify();			
		}
		
		//
		//	  callsWithArguments
		//
		
		[Test]
		public function callsWithArguments_shouldCallFunctionWithInvocationArguments():void 
		{
			var receivedArguments:Array;
			
			mocker.method("example").args(Number, Array).callsWithArguments(function(a:int, b:Array):void {
				receivedArguments = [a, b];
			});
			invoke({ name: "example", arguments: [1, [2]] });
			
			assertThat(receivedArguments, array(1, array(2)));
		}
	}
}