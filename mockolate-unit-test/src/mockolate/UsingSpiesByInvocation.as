package mockolate
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import mockolate.*;
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.Spy;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.object.*;

	public class UsingSpiesByInvocation
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var dispatcher:IEventDispatcher;

		public var event:Event;

		public var spy:Spy;

		[Before]
		public function setup():void 
		{
			mocks.expect(dispatcher.dispatchEvent(arg(Event))).returns(true);
			spy = mocks.spy(dispatcher.dispatchEvent(arg(Event)));
			event = new Event(Event.COMPLETE);
			dispatcher.dispatchEvent(event);
		}

		[Test]
		public function called():void 
		{
			assertThat(spy.called, isTrue());
		}

		[Test]
		public function calledOnce():void 
		{
			assertThat(spy.calledOnce, isTrue());
		}

		[Test]
		public function calledTwice():void 
		{
			assertThat(spy.calledTwice, isFalse());
		}

		[Test]
		public function calledThrice():void 
		{
			assertThat(spy.calledThrice, isFalse());
		}

		[Test]
		public function called_with_matching_value():void 
		{
			assertThat(spy.calledWith(event), isTrue());
		}

		[Test]
		public function called_with_matching_class():void 
		{
			assertThat(spy.calledWith(Event), isTrue());
		}

		[Test]
		public function calledWith_with_matching_matcher():void 
		{
			assertThat(spy.calledWith(hasProperties({ type: Event.COMPLETE })), isTrue());
		}

		[Test]
		public function calledWith_with_mismatched_matcher():void 
		{
			assertThat(spy.calledWith(hasProperties({ type: Event.CANCEL })), isFalse());
		}

		[Test]
		public function calledWith_with_mismatched_value():void 
		{
			assertThat(spy.calledWith(1, 2, 3), isFalse());
		}

		[Test]
		public function calledWithExactly_with_matching_value():void 
		{
			assertThat(spy.calledWithExactly(event), isTrue());
		}

		[Test]
		public function calledWithExactly_with_mismatched_value():void 
		{
			assertThat(spy.calledWithExactly(Event), isFalse());
		}

		[Test]
		public function alwasyCalledWith_with_matching_value():void 
		{
			assertThat(spy.alwaysCalledWith(Event), isTrue());
		}

		[Test]
		public function alwaysCalledWithExactly_with_matching_value():void 
		{
			assertThat(spy.alwaysCalledWithExactly(event), isTrue());
		}

		[Test]
		public function alwaysCalledWithExactly_with_mismatched_value():void 
		{
			assertThat(spy.alwaysCalledWithExactly(new Event(Event.COMPLETE)), isFalse());
		}

		[Test]
		public function neverCalledWith_matching_value():void 
		{
			assertThat(spy.neverCalledWith(Event), isFalse());
		}

		[Test]
		public function neverCalledWith_with_mismatched_value():void 
		{
			assertThat(spy.neverCalledWith(1, 2, 3), isTrue());
		}

		[Test]
		public function threw_with_no_value():void 
		{
			assertThat(spy.threw(), isFalse());
		}

		[Test]
		public function threw_with_mismatched_value():void 
		{
			assertThat(spy.threw(ArgumentError), isFalse());
		}

		[Test]
		public function alwaysThrew_with_no_value():void 
		{
			assertThat(spy.alwaysThrew(), isFalse());
		}

		[Test]
		public function alwaysThrew_with_mismatched_value():void 
		{
			assertThat(spy.alwaysThrew(ArgumentError), isFalse());
		}

		private function throwError():void 
		{
			try
			{
				dispatcher = mocks.nice(IEventDispatcher);
				spy = mocks.spy(dispatcher.dispatchEvent(arg(Event)));
				mocks.expect(dispatcher.dispatchEvent(arg(Event))).throws(new ArgumentError("No Event"));			
				dispatcher.dispatchEvent(event);
			}
			catch (error:Error)
			{
				// carry on. 
			}
		}

		[Test]
		public function threw_when_error_has_been_thrown():void 
		{
			throwError();
			assertThat(spy.threw(), isTrue());
		}

		[Test]
		public function alwaysThrew_when_error_has_been_thrown():void 
		{
			throwError();
			assertThat(spy.alwaysThrew(), isTrue());
		}

		[Test]
		public function alwaysThrew_with_matching_value():void 
		{
			throwError();
			assertThat(spy.alwaysThrew(ArgumentError), isTrue());
		}

		[Test]
		public function returned_with_matching_value():void 
		{
			assertThat(spy.returned(true), isTrue());
		}

		[Test]
		public function returned_with_mismatched_value():void 
		{
			assertThat(spy.returned(123), isFalse());
		}

		[Test]
		public function alwaysReturned():void 
		{
			assertThat(spy.alwaysReturned(true), isTrue());
		}

		[Test]
		public function invocations():void 
		{
			assertThat(spy.invocations, array(instanceOf(Invocation)));
		}

		[Test]
		public function firstInvocation():void 
		{
			assertThat(spy.firstInvocation, instanceOf(Invocation));
		}

		[Test]
		public function lastInvocation():void 
		{
			assertThat(spy.lastInvocation, equalTo(spy.firstInvocation));
		}

		[Test]
		public function errors():void 
		{
			assertThat(spy.errors, emptyArray());
		}

		[Test]
		public function arguments():void 
		{
			assertThat(spy.arguments, equalTo([ [event] ]));
		}

		[Test]
		public function arguments_by_index():void 
		{
			assertThat(spy.arguments[0], array(event));
		}

		[Test]
		public function returnValue():void
		{
			assertThat(spy.returnValues, array(true));
		}
	}	
}