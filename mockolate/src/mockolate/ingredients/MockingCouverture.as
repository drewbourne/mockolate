package mockolate.ingredients
{
	import asx.array.contains;
	import asx.array.detect;
	import asx.array.empty;
	import asx.array.filter;
	import asx.array.map;
	import asx.array.reject;
	import asx.fn.getProperty;
	import asx.string.substitute;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import mockolate.decorations.Decorator;
	import mockolate.decorations.EventDispatcherDecorator;
	import mockolate.decorations.InvocationDecorator;
	import mockolate.decorations.rpc.HTTPServiceDecorator;
	import mockolate.errors.ExpectationError;
	import mockolate.errors.InvocationError;
	import mockolate.errors.MockolateError;
	import mockolate.errors.VerificationError;
	import mockolate.ingredients.MockolatierMaster;
	import mockolate.ingredients.answers.Answer;
	import mockolate.ingredients.answers.CallsAnswer;
	import mockolate.ingredients.answers.CallsSuperAnswer;
	import mockolate.ingredients.answers.CallsWithInvocationAnswer;
	import mockolate.ingredients.answers.DispatchesEventAnswer;
	import mockolate.ingredients.answers.MethodInvokingAnswer;
	import mockolate.ingredients.answers.ReturnsAnswer;
	import mockolate.ingredients.answers.ThrowsAnswer;

	import mx.rpc.http.HTTPService;

	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	import org.hamcrest.StringDescription;
	import org.hamcrest.collection.IsArrayMatcher;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.core.anyOf;
	import org.hamcrest.core.anything;
	import org.hamcrest.core.describedAs;
	import org.hamcrest.date.dateEqual;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.number.lessThan;
	import org.hamcrest.number.lessThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.text.re;

	use namespace mockolate_ingredient;

	/**
	 * Mock and Stub behaviour of the target, such as:
	 *
	 * <ul>
	 * <li>return values, </li>
	 * <li>calling functions, </li>
	 * <li>dispatching events, </li>
	 * <li>throwing errors. </li>
	 * </ul>
	 *
	 * @author drewbourne
	 */
	public class MockingCouverture
		extends Couverture
		implements IMockingMethodCouverture, IMockingGetterCouverture, IMockingSetterCouverture, IMockingCouverture
	{
		private var _invokedAs:Object;
		private var _expectations:Array;
		private var _mockExpectations:Array;
		private var _stubExpectations:Array;
		private var _currentExpectation:Expectation;
		private var _expectationsAsMocks:Boolean;
		private var _decoratorClassesByClass:Dictionary;
		private var _decorations:Array;
		private var _decorationsByClass:Dictionary;
		private var _invocationDecorations:Array;

		/**
		 * Constructor.
		 */
		public function MockingCouverture(mockolate:Mockolate)
		{
			super(mockolate);

			_expectations = [];
			_mockExpectations = [];
			_stubExpectations = [];
			_expectationsAsMocks = true;
			_decorations = [];
			_invocationDecorations = [];
			_decorationsByClass = new Dictionary();

			_decoratorClassesByClass = new Dictionary();
			_decoratorClassesByClass[IEventDispatcher] = EventDispatcherDecorator;
			_decoratorClassesByClass[EventDispatcher] = EventDispatcherDecorator;
			_decoratorClassesByClass[HTTPService] = HTTPServiceDecorator;
		}

		//
		//	Public API
		//

		//
		//	mocking and stubbing behaviours
		//

		/**
		 * Use <code>mock()</code> when you want to ensure that method or
		 * property is called.
		 *
		 * Sets the expectation mode to create required Expectations. Required
		 * Expectations will be checked when <code>verify(instance)</code> is
		 * called.
		 *
		 * @see mockolate#mock()
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("toString").returns("[Instance]");
		 * </listing>
		 */
		public function mock():MockingCouverture
		{
			_expectationsAsMocks = true;
			return this;
		}

		/**
		 * Use <code>stub()</code> when you want to add behaviour to a method
		 * or property that MAY be used.
		 *
		 * Sets the expectation mode to create possible expectations. Possible
		 * Expectations will NOT be checked when <code>verify(instance)</code>
		 * is called. They are used to define support behaviour.
		 *
		 * @see mockolate#stub()
		 *
		 * @example
		 * <listing version="3.0">
		 *	stub(instance).method("toString").returns("[Instance]");
		 * </listing>
		 */
		public function stub():MockingCouverture
		{
			_expectationsAsMocks = false;
			return this;
		}

		/**
		 * Defines an Expectation of the given method name.
		 *
		 * @param name Name of the method to expect.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("toString").returns("[Instance]");
		 * </listing>
		 */
		public function method(name:String):IMockingMethodCouverture
		{
			// FIXME this _really_ should check that the method actually exists on the Class we are mocking
			// FIXME when this checks if the method exists, remember we have to support Proxy as well!

			createMethodExpectation(name, null);

			return this;
		}

		/**
		 * Defines an Expectation of the given namespaced method name.
		 *
		 * @param namespace Namespace of the method to expect.
		 * @param name Name of the method to expect.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).nsMethod(flash_proxy, "getProperty").returns("[Instance]");
		 * </listing>
		 */
		public function nsMethod(ns:Namespace, name:String):IMockingMethodCouverture
		{
			// FIXME this _really_ should check that the method actually exists on the Class we are mocking
			// FIXME when this checks if the method exists, remember we have to support Proxy as well!

			createMethodExpectation(name, ns);

			return this;
		}

		/**
		 * Defines an Expectation for methods with a name that matches the given RegExp.
		 *
		 * @param regexp RegExp the method name should match.
		 *
		 * @example
		 * <listing version="3.0">
		 * 	mock(permissions).methods(/^allow/).returns(true);
		 *
		 * 	if (permissions.allowEdit(value)) {
		 * 		// do edit.
		 * 	}
		 *
		 * 	if (permissions.allowView(value)) {
		 * 		// do view.
		 * 	}
		 * </listing>
		 */
		public function methods(regexp:RegExp):IMockingMethodCouverture
		{
			createMethodsExpectation(regexp);

			return this;
		}

		/**
		 * Defines an Expectation to get a property value.
		 *
		 * @param name Name of the property
		 *
		 * @example
		 * <listing version="3.0">
		 * 	stub(instance).getter("name").returns("Current Name");
		 * </listing>
		 */
		public function getter(name:String/*, ns:String=null*/):IMockingGetterCouverture
		{
			createGetterExpectation(name);

			return new MockingGetterCouverture(this.mockolateInstance);
		}

		/**
		 * Defines an Expectation to get a property value for any property with a name that matches the RegExp.
		 *
		 * @param name Name of the property
		 *
		 * @example
		 * <listing version="3.0">
		 * 	stub(instance).getters(/^slot\d/).returns(42);
		 *
		 * 	trace(instance.slot0) 	// matches
		 *  trace(instance.slot1) 	// matches
		 *  trace(instance.slot10) 	// does not match
		 * </listing>
		 */
		public function getters(regexp:RegExp):IMockingGetterCouverture
		{
			createGettersExpectation(regexp);

			return new MockingGetterCouverture(this.mockolateInstance);
		}

		/**
		 * Defines an Expectation to get a property value.
		 *
		 * @param ns Namespace of the getter
		 * @param name Name of the getter
		 *
		 * @example
		 * <listing version="3.0">
		 * 	stub(instance).getter("name").returns("Current Name");
		 * </listing>
		 */
		public function nsGetter(ns:Namespace, name:String):IMockingGetterCouverture
		{
			createGetterExpectation(name, ns);

			return new MockingGetterCouverture(this.mockolateInstance);
		}

		/**
		 * Defines an Expectation to set a property value.
		 *
		 * @param name Name of the property
		 *
		 * @example
		 * <listing version="3.0">
		 * 	stub(instance).setter("name").arg("New Name");
		 * </listing>
		 */
		public function setter(name:String/*, ns:String=null*/):IMockingSetterCouverture
		{
			createSetterExpectation(name);

			return new MockingSetterCouverture(this.mockolateInstance);
		}

		/**
		 * Defines an Expectation to set a property value for any property with a name that matches the RegExp.
		 *
		 * @param name Name of the property
		 *
		 * @example
		 * <listing version="3.0">
		 * 	stub(instance).setters(/^slot\d/).arg(Number);
		 *
		 * 	instance.slot0 = 1;		// matches
		 * 	instance.slot9 = 3;		// matches
		 * 	instance.slot10 = 4; 	// does not match
		 * </listing>
		 */
		public function setters(regexp:RegExp):IMockingSetterCouverture
		{
			createSettersExpectation(regexp);

			return new MockingSetterCouverture(this.mockolateInstance);
		}

		/**
		 * Defines an Expectation to set a property value.
		 *
		 * @param name Name of the property
		 *
		 * @example
		 * <listing version="3.0">
		 * 	stub(instance).setter("name").arg("New Name");
		 * </listing>
		 */
		public function nsSetter(ns:Namespace, name:String):IMockingSetterCouverture
		{
			createSetterExpectation(name, ns);

			return new MockingSetterCouverture(this.mockolateInstance);
		}

		/**
		 * Use <code>arg()</code> to define a single value or Matcher as the
		 * expected arguments. Typically used with property expectations to
		 * define the expected argument value for the property setter.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).property("enabled").arg(Boolean);
		 * </listing>
		 */
		public function arg(value:Object):IMockingSetterCouverture
		{
			// FIXME this _really_ should check that the method or property accepts the number of matchers given.
			// we can ignore the types of the matchers though, it will fail when run if given incorrect values.

			setArgs([value]);
			return this;
		}

		/**
		 * Use <code>args()</code> to define the values or Matchers to expect as
		 * arguments when the method (or property) is invoked.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("add").args(Number, Number).returns(42);
		 * </listing>
		 */
		public function args(... rest):IMockingMethodCouverture
		{
			// FIXME this _really_ should check that the method or property accepts the number of matchers given.
			// we can ignore the types of the matchers though, it will fail when run if given incorrect values.

			setArgs(rest);
			return this;
		}

		/**
		 * Use <code>noArgs()</code> to define that arguments are not expected
		 * when the method is invoked.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("toString").noArgs();
		 * </listing>
		 */
		public function noArgs():IMockingMethodCouverture
		{
			// FIXME this _really_ should check that the method or property accepts no arguments.

			setNoArgs();
			return this;
		}

		/**
		 * Use <code>anyArgs()</code> to define that the current Expectation
		 * should be invoked for any arguments.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("arbitrary").anyArgs();
		 *
		 *	instance.arbitrary(1, 2, 3);
		 * </listing>
		 */
		public function anyArgs():IMockingMethodCouverture
		{
			setAnyArgs();
			return this;
		}

		/**
		 * Sets the value to return when the current Expectation is invoked.
		 *
		 * If more than 1 return value is given a value will be returned in
		 * sequence from first to last each time the method is invoked. The last
		 * value in the sequence will be repeated if invoked more times than the
		 * number of values.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("toString").returns("[Instance]");
		 *	trace(instance.toString());
		 *	// "[Instance]"
		 *
		 * 	mock(otherInstance).method("gimme").returns(1, 2, 3);
		 * 	trace(otherInstance.gimme());
		 * 	// 1
		 * 	trace(otherInstance.gimme());
		 * 	// 2
		 * 	trace(otherInstance.gimme());
		 * 	// 3
		 * 	trace(otherInstance.gimme());
		 * 	// 3
		 * </listing>
		 */
		public function returns(value:*, ...values):IMockingCouverture
		{
			// FIXME first set returns() value wins, should be last.

			addReturns.apply(null, [ value ].concat(values));
			return this;
		}

		/**
		 * Causes the current Expectation to throw the given Error when invoked.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("explode").throws(new ExplodyError("Boom!"));
		 *
		 *	try
		 *	{
		 *		instance.explode();
		 *	}
		 *	catch (error:ExplodyError)
		 *	{
		 *		// error handling.
		 *	}
		 * </listing>
		 */
		public function throws(error:Error):IMockingCouverture
		{
			addThrows(error);
			return this;
		}

		/**
		 * Calls the given Function with the given arguments when the current
		 * Expectation is invoked.
		 *
		 * Note: does NOT pass anything from the Invocation to the function.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("message").calls(function(a:int, b:int):void {
		 *		trace("message", a, b);
		 *		// "message 1 2"
		 *	}, [1, 2]);
		 * </listing>
		 */
		public function calls(fn:Function, args:Array=null):IMockingCouverture
		{
			addCalls(fn, args);
			return this;
		}

		/**
		 * Calls the given Function with the Invocation when the current
		 * Expectation is invoked.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("message").callsWithInvocation(function(invocation:Invocation):void {
		 * 		trace(invocation.name, invocation.arguments);
		 * 	});
		 *
		 * 	instance.message(1, [2, 3]);
		 * </listing>
		 */
		public function callsWithInvocation(fn:Function, args:Array=null):IMockingCouverture
		{
			addCallsWithInvocationAnswer(fn, args);
			return this;
		}

		/**
		 * Calls the given Function with the Invocation.arguments when the
		 * current Expectation is invoked.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("message").callsWithArguments(function(a:int, b:Array):void {
		 * 		trace("message", a, b);
		 * 	});
		 *
		 * 	instance.message(1, [2, 3]);
		 * </listing>
		 */
		public function callsWithArguments(fn:Function, args:Array=null):IMockingCouverture
		{
			addCallsWithArgumentsAnswer(fn, args);
			return this;
		}

		/**
		 * Causes the current Expectation to dispatch the given Event with an
		 * optional delay when invoked.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("update").dispatches(new Event("updated"), 300);
		 * </listing>
		 */
		public function dispatches(event:Event, delay:Number=0):IMockingCouverture
		{
			addDispatches(event, delay);
			return this;
		}

		/**
		 * Causes the current Expectation to invoke the given Answer subclass.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("update").answers(new CustomAnswer());
		 * </listing>
		 */
		public function answers(answer:Answer):IMockingCouverture
		{
			addAnswer(answer);
			return this;
		}

		//
		//	verification behaviours
		//

		/**
		 * Sets the current Expectation to expect to be called the given 
		 * number of times. 
		 * 
		 * If the Expectation has not been invoked the correct number of times 
		 * when <code>verify()</code> is called then an ExpectationError will 
		 * be thrown.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("say").times(3);
		 *
		 *	instance.say();
		 *	instance.say();
		 *	instance.say();
		 *
		 *	verify(instance);
		 * </listing>
		 */
		public function times(n:int):IMockingCouverture
		{
			setInvokeCount(lessThanOrEqualTo(n), equalTo(n));
			return this;
		}

		/**
		 * Sets the current Expectation to expect not to be called. 
		 * 
		 * If the Expectation has been invoked then when <code>verify()</code> 
		 * is called then an ExpecationError will be thrown.
		 * 
		 * @see #times()
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("deprecatedMethod").never();
		 * </listing>
		 */
		public function never():IMockingCouverture
		{
			setInvokeCount(greaterThanOrEqualTo(0), equalTo(0));
			callsWithInvocation(function(invocation:Invocation):void {
				var description:Description = new StringDescription();
				
				description
					.appendDescriptionOf(mockolateInstance)
					.appendText(".")
					.appendDescriptionOf(invocation);

				throw new InvocationError(
					["Unexpected invocation for {}", [description.toString()]],
					invocation, mockolateInstance, mockolateInstance.target);
			});
			return this;
		}

		/**
		 * Sets the current Expectation to expect to be called once.
		 *
		 * @see #times()
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("say").once();
		 *
		 *	instance.say();
		 *
		 *	verify(instance);
		 * </listing>
		 */
		public function once():IMockingCouverture
		{
			return times(1);
		}

		/**
		 * Sets the current Expectation to expect to be called two times.
		 *
		 * @see #times()
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("say").twice();
		 *
		 *	instance.say();
		 *	instance.say();
		 *
		 *	verify(instance);
		 * </listing>
		 */
		public function twice():IMockingCouverture
		{
			return times(2);
		}

		// at the request of Brian LeGros we have thrice()
		/**
		 * Sets the current Expectation to expect to be called three times.
		 *
		 * @see #times()
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("say").thrice();
		 *
		 *	instance.say();
		 *	instance.say();
		 *	instance.say();
		 *
		 *	verify(instance);
		 * </listing>
		 */
		public function thrice():IMockingCouverture
		{
			return times(3);
		}

		/**
		 * Sets the current Expectation to expect to be called at least the
		 * given number of times.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("say").atLeast(2);
		 *
		 *	instance.say();
		 *	instance.say();
		 *	instance.say();
		 *
		 *	verify(instance);
		 * </listing>
		 */
		public function atLeast(n:int):IMockingCouverture
		{
			setInvokeCount(greaterThanOrEqualTo(0), greaterThanOrEqualTo(n));
			return this;
		}

		/**
		 * Sets the current Expectation to expect to be called at most the
		 * given number of times.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("say").atMost(2);
		 *
		 *	instance.say();
		 *
		 *	verify(instance);
		 * </listing>
		 */
		public function atMost(n:int):IMockingCouverture
		{
			setInvokeCount(lessThanOrEqualTo(n), lessThanOrEqualTo(n));
			return this;
		}

		/**
		 * Sets the current Expectation to expect to be called in order.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance1).method("sort").ordered("execution order sensitive");
		 *	mock(instance2).method("sort").ordered("execution order sensitive");
		 * </listing>
		 */
		public function ordered(sequence:Sequence):IMockingCouverture
		{
			addOrdered(sequence);
			return this;
		}

		/**
		 * Sets the current Expectation to invoke the super method or property.
		 *
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("addEventListener").anyArgs().callsSuper();
		 * </listing>
		 */
		public function callsSuper():IMockingCouverture
		{
			addCallsSuper();
			return this;
		}

		/**
		 * @example
		 * <listing version="3.0">
		 *	(mock(httpService).decorate(HTTPService) as HTTPServiceDecorator)
		 *		.send("What is the ultimate answer to life, the universe, everything?")
		 *		.result(42)
		 * </listing>
		 */
		public function decorate(classToDecorate:Class, decoratorClass:Class = null):Decorator
		{
			// the decorators may define new expectations
			// as such we need to reinstate the current expecation
			// after the decorator has been created.

			var previousExpectation:Expectation = _currentExpectation;
			var decorator:Decorator = createDecoratorFor(classToDecorate, decoratorClass);
			_currentExpectation = previousExpectation;

			return decorator;
		}

		//
		//	Decorators
		//

		/**
		 * Decorates the current instance with stubbed behaviour for an EventDispatcher.
		 */
		public function asEventDispatcher():EventDispatcherDecorator
		{
			var wasExpectingMocks:Boolean = _expectationsAsMocks;
			_expectationsAsMocks = false;
			var decorator:EventDispatcherDecorator = stub().decorate(IEventDispatcher) as EventDispatcherDecorator;
			_expectationsAsMocks = wasExpectingMocks;
			return decorator;
		}

		/**
		 * Returns a HTTPServiceDecorator around the current instance to provide
		 * an easier API for mocking HTTPService calls.
		 */
		public function asHTTPService():HTTPServiceDecorator
		{
			return decorate(HTTPService) as HTTPServiceDecorator;
		}

		//
		//	Internal API
		//

		/**
		 * Gets a copy of the Array of Expectations.
		 *
		 * @private
		 */
		mockolate_ingredient function get expectations():Array
		{
			return _expectations.slice(0);
		}

		/**
		 * Finds the first Expectation that returns <code>true</code> for
		 * <code>Expectation.eligible(Invocation)</code> with the given Invocation.
		 *
		 * @private
		 */
		protected function findEligibleExpectation(invocation:Invocation):Expectation
		{
			var expectation:Expectation;
			expectation = detect(_mockExpectations, isEligibleExpectation, invocation) as Expectation;
			expectation ||= detect(_stubExpectations, isEligibleExpectation, invocation) as Expectation;

			// regardless of MockType, 
			// when there is no expectation
			// and the invocation namespaced
			// then proceed with the super call
			// as most uses of namespace are for internals
			// and intercepting them needlessly is surprising to the user.
			//
			if (!expectation && invocation.uri)
			{
				invocation.proceed();
			}
			
			if (!expectation)
			{
				if (mockolateInstance.mockType == MockType.STRICT)
				{
					var description:Description = new StringDescription();

					description
						.appendDescriptionOf(this.mockolateInstance)
						.appendText(".")
						.appendDescriptionOf(invocation);

					throw new InvocationError(
						["No Expectation defined for {}", [description.toString()]],
						invocation, this.mockolateInstance, this.mockolateInstance.target);
				}

				if (mockolateInstance.mockType == MockType.PARTIAL)
				{
					expectation = createExpectation(invocation.name, null, null, invocation.invocationType);
					expectation.addAnswer(new CallsSuperAnswer());
				}
			}

			return expectation;
		}

		/**
		 * @private
		 */
		protected function isEligibleExpectation(expectation:Expectation, invocation:Invocation):Boolean
		{
			return expectation.eligible(invocation);
		}

		/**
		 * Called when a method or property is invoked on an instance created by
		 * Mockolate.
		 *
		 * @private
		 */
		override mockolate_ingredient function invoked(invocation:Invocation):void
		{
			invokeDecorators(invocation);

			invokeExpectation(invocation);
		}

		/**
		 * Invoke Decorators.
		 *
		 * @private
		 */
		protected function invokeDecorators(invocation:Invocation):void
		{
			for each (var decorator:Decorator in _invocationDecorations)
			{
				decorator.invoked(invocation);
			}
		}

		/**
		 * Find and invoke the first eligible Expectation.
		 *
		 * @private
		 */
		protected function invokeExpectation(invocation:Invocation):void
		{
			var expectation:Expectation = findEligibleExpectation(invocation);
			if (expectation)
			{
				expectation.invoke(invocation);
			}
		}

		/**
		 * Create an Expectation.
		 *
		 * @see #createMethodExpectation
		 * @see #createGetterExpectation
		 * @see #createSetterExpectation
		 *
		 * @private
		 */
		protected function createExpectation(name:String, ns:Namespace=null, nameMatcher:Matcher=null, invocationType:InvocationType=null):Expectation
		{
			var expectation:Expectation = new Expectation();
			expectation.name = name;
			expectation.namespace = ns;
			expectation.nameMatcher = nameMatcher || equalTo(name);
			expectation.invocationType = invocationType;
			return expectation;
		}

		/**
		 * Adds an Expectation.
		 *
		 * @private
		 */
		protected function addExpectation(expectation:Expectation):Expectation
		{
			_expectations[_expectations.length] = expectation;

			if (_expectationsAsMocks)
				_mockExpectations[_mockExpectations.length] = expectation;
			else
				_stubExpectations[_stubExpectations.length] = expectation;

			expectationAdded();

			return expectation;
		}

		/**
		 * Called after an Expectation has been added.
		 */
		protected function expectationAdded():void
		{
			// when expectation mode is mock
			// than should be called at least once
			// -- will be overridden if set by the user.
			if (_expectationsAsMocks)
			{
				atLeast(1);
			}
		}

		/**
		 * Creates a Expectation for a getter.
		 *
		 * @private
		 */
		protected function createGetterExpectation(name:String, ns:Namespace=null):void
		{
			_currentExpectation = createExpectation(name, ns, null, InvocationType.GETTER);

			addExpectation(_currentExpectation);
		}

		/**
		 * Creates a Expectation for a getters with names that match the given RegExp.
		 *
		 * @private
		 */
		protected function createGettersExpectation(regexp:RegExp):void
		{
			_currentExpectation = createExpectation(regexp.toString(), null, re(regexp), InvocationType.GETTER);

			addExpectation(_currentExpectation);
		}

		/**
		 * Creates an Expectation for a setter.
		 *
		 * @private
		 */
		protected function createSetterExpectation(name:String, ns:Namespace=null):void
		{
			_currentExpectation = createExpectation(name, ns, null, InvocationType.SETTER);

			addExpectation(_currentExpectation);
		}

		/**
		 * Creates an Expectation for a setters with names that match the given RegExp.
		 *
		 * @private
		 */
		protected function createSettersExpectation(regexp:RegExp):void
		{
			_currentExpectation = createExpectation(regexp.toString(), null, re(regexp), InvocationType.SETTER);

			addExpectation(_currentExpectation);
		}

		/**
		 * Create an Expectation for a method.
		 *
		 * @private
		 */
		protected function createMethodExpectation(name:String, ns:Namespace=null):void
		{
			_currentExpectation = createExpectation(name, ns, null, InvocationType.METHOD);

			addExpectation(_currentExpectation);
		}

		/**
		 * Create an Expectation for methods with names that match the given RegExp.
		 *
		 * @private
		 */
		protected function createMethodsExpectation(regexp:RegExp):void
		{
			_currentExpectation = createExpectation(regexp.toString(), null, re(regexp), InvocationType.METHOD);

			addExpectation(_currentExpectation);
		}

		/**
		 * @private
		 */
		protected function setArgs(args:Array):void
		{
			_currentExpectation.argsMatcher = describedAs(
				new StringDescription().appendList("", ",", "", args).toString(),
				new IsArrayMatcher(map(args, valueToMatcher)));
		}

		/**
		 * @private
		 */
		protected function setNoArgs():void
		{
			_currentExpectation.argsMatcher = describedAs("", anyOf(nullValue(), emptyArray()));
		}

		/**
		 * @private
		 */
		protected function setAnyArgs():void
		{
			_currentExpectation.argsMatcher = anything();
		}

		// FIXME rename setReceiveCount to something better
		/**
		 * @private
		 */
		protected function setInvokeCount(
			eligiblityMatcher:Matcher,
			verificationMatcher:Matcher):void
		{
			_currentExpectation.invokeCountEligiblityMatcher = eligiblityMatcher;
			_currentExpectation.invokeCountVerificationMatcher = verificationMatcher;
		}

		/**
		 * @private
		 */
		protected function addAnswer(answer:Answer):void
		{
			if (answer)
				_currentExpectation.addAnswer(answer);
		}

		/**
		 * @private
		 */
		protected function addThrows(error:Error):void
		{
			addAnswer(new ThrowsAnswer(error));
		}

		/**
		 * @private
		 */
		protected function addDispatches(event:Event, delay:Number=0):void
		{
			var wasExpectingMocks:Boolean = _expectationsAsMocks;
			_expectationsAsMocks = false;
			var eventDispatcherDecorator:EventDispatcherDecorator = decorate(IEventDispatcher) as EventDispatcherDecorator;
			_expectationsAsMocks = wasExpectingMocks;
			addAnswer(new DispatchesEventAnswer(eventDispatcherDecorator.eventDispatcher, event, delay));
		}

		/**
		 * @private
		 */
		protected function addCalls(fn:Function, args:Array=null):void
		{
			addAnswer(new CallsAnswer(fn, args));
		}

		/**
		 * @private
		 */
		protected function addCallsWithInvocationAnswer(fn:Function, args:Array=null):void
		{
			addAnswer(new CallsWithInvocationAnswer(fn, args));
		}

		/**
		 * @private
		 */
		protected function addCallsWithArgumentsAnswer(fn:Function, args:Array=null):void
		{
			addAnswer(new CallsWithInvocationAnswer(function(invocation:Invocation):* {
				var fnArgs:Array = (invocation.arguments || []);
				fnArgs = fnArgs.concat(args || []);
				return fn.apply(null, fnArgs);
			}));
		}

		/**
		 * @private
		 */
		protected function addReturns(value:*, ...values):void
		{
			addAnswer(new ReturnsAnswer([ value ].concat(values)));
		}

		/**
		 * @private
		 */
		protected function addCallsSuper():void
		{
			addAnswer(new CallsSuperAnswer());
		}

		/**
		 * @private
		 */
		protected function addOrdered(sequence:Sequence):void
		{
			sequence.constrainAsNextInSequence(_currentExpectation);
		}

		/**
		 * @private
		 */
		protected function createDecoratorFor(classToDecorate:Class, decoratorClass:Class):Decorator
		{
			if (!decoratorClass)
				decoratorClass = _decoratorClassesByClass[classToDecorate];

			if (!decoratorClass)
			{
				throw new MockolateError(
					["No Decorator registered for {0}", [classToDecorate]],
					this.mockolateInstance, this.mockolateInstance.target);
			}

			var decorator:Decorator = _decorationsByClass[classToDecorate];

			if (!decorator)
			{
				decorator = new decoratorClass(this.mockolateInstance);

				_decorations[_decorations.length] = decorator;
				_decorationsByClass[classToDecorate] = decorator;

				if (decorator is InvocationDecorator)
					_invocationDecorations[_invocationDecorations.length] = decorator;
			}

			return decorator;
		}

		/**
		 * @private
		 */
		override mockolate_ingredient function verify():void
		{
			// mock expectations are always verified

			var unmetExpectations:Array = reject(_mockExpectations, verifyExpectation);
			if (!empty(unmetExpectations))
			{
				var message:String = unmetExpectations.length.toString();

				message += unmetExpectations.length == 1
					? " unmet Expectation"
					: " unmet Expectations";

				for each (var expectation:Expectation in unmetExpectations)
				{
					message += "\n\t";
					// TODO move to mockolate.targetClassName
					message += getQualifiedClassName(this.mockolateInstance.targetClass);

					if (this.mockolateInstance.name)
						message += "<\"" + this.mockolateInstance.name + "\">";

					// TOOD include more description from the Expectation
					message += expectation.toString();
				}

				throw new ExpectationError(
					message,
					unmetExpectations,
					this.mockolateInstance,
					this.mockolateInstance.target);
			}

			// stub expectations are not verified
		}

		/**
		 * @private
		 */
		protected function verifyExpectation(expectation:Expectation):Boolean
		{
			return expectation.satisfied;
		}
	}
}
