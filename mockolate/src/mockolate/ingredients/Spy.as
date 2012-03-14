package mockolate.ingredients
{
	import asx.array.first;
	import asx.array.last;
	import asx.array.pluck;
	import asx.array.some;
	import asx.array.every;
	import asx.array.empty;
	import asx.array.map;
	import asx.array.compact;

	import org.hamcrest.Matcher;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.object.*;

	use namespace mockolate_ingredient;

	/**
	 * A Test Spy records invocations of a specific method, getter or setter. 
	 * It exposes the list of invocations, their arguments, return values, and
	 * any errors that have been thrown. The handler (typically a testcase) can 
	 * then check the recorded invocations against what should or should not 
	 * have occurred and take action (typically an assertion).
	 *
	 * Create a Test Spy by wrapping a call to the method, getter or setter of 
	 * a Mock Object in <code>mockolate#spy()</code> or 
	 * <code>MockolateRule#spy()</code>. 
	 *
	 * @see mockolate#spy()
	 * @see mockolate.runner.MockolateRule#spy()
	 */
	public class Spy extends Couverture
	{
		private var _invocationMatcher:Matcher;
		private var _invocations:Array;

		/**
		 * Constructor.
		 * 
		 * @param mockolateInstance 
		 * @param invocation Used to select which invocations this Spy should record.
		 * @param args Used to select which invocations this Spy should record.
		 */
		public function Spy(mockolateInstance:Mockolate, invocation:Invocation, args:Array)
		{
			super(mockolateInstance);

			_invocationMatcher = new InvocationMatcher(invocation, args);
			_invocations = [];
		}

		/**
		 * Called by the Mockolate when an Invocation is received, and records the
		 * invocation if it maches the invocation and arguments required by this Spy.
		 */
		override mockolate_ingredient function invoked(invocation:Invocation):Boolean
		{
			if (_invocationMatcher.matches(invocation))
			{
				_invocations.push(invocation);
			}

			return false;
		}

		/**
		 * Returns the list of recorded Invocations. 
		 */
		public function get invocations():Array
		{
			return _invocations;
		}

		/**
		 * Returns the first recorded Invocation.
		 */
		public function get firstInvocation():Invocation
		{
			return first(_invocations) as Invocation;
		}
		
		/**
		 * Returns the last recorded Invocation.
		 */
		public function get lastInvocation():Invocation
		{
			return last(_invocations) as Invocation;
		}

		/**
		 * Returns an Array of the arguments from each Invocation.
		 */
		public function get arguments():Array
		{
			return pluck(_invocations, 'arguments');
		}
		
		/**
		 * Returns an Array of the return values from each Invocation.
		 */
		public function get returnValues():Array
		{
			return pluck(_invocations, 'returnValue');
		}
		
		/**
		 * Returns an Array of the errors from each Invocation. 
		 * Filtered to remove null values. 
		 */
		public function get errors():Array
		{
			return compact(pluck(_invocations, 'error'));
		}
		
		/**
		 * Indicates if the Spy recorded any matching Invocations.
		 */
		public function get called():Boolean
		{
			return !empty(_invocations);
		}
		
		/**
		 * Indicates if the Spy recorded exactly one Invocation.
		 */
		public function get calledOnce():Boolean
		{
			return _invocations.length === 1;
		}
		
		/**
		 * Indicates if the Spy recorded exactly two Invocation.
		 */
		public function get calledTwice():Boolean
		{
			return _invocations.length === 2;
		}
		
		/**
		 * Indicates if the Spy recorded exactly three Invocation.
		 */
		public function get calledThrice():Boolean
		{
			return _invocations.length === 3;
		}
		
		/**
		 * Checks if the any of the recorded Invocations were called with the given arguments.
		 */
		public function calledWith(...args):Boolean
		{	
			return arrayMatchesAny(arguments, new ArgumentsMatcher(args));
		}
		
		/**
		 * Checks if the any of the recorded Invocations were called with exactly the given arguments.
		 */
		public function calledWithExactly(...args):Boolean
		{
			return some(arguments, array.apply(null, map(args, equalTo)).matches);
		}
		
		/**
		 * Checks if the all of the recorded Invocations were called with the given arguments.
		 */
		public function alwaysCalledWith(...args):Boolean
		{
			return arrayMatchesAll(arguments, new ArgumentsMatcher(args));
		}
		
		/**
		 * Checks if the all of the recorded Invocations were called with exactly the given arguments.
		 */
		public function alwaysCalledWithExactly(...args):Boolean
		{
			return every(arguments, array.apply(null, map(args, equalTo)).matches);
		}
		
		/**
		 * Checks if none of the recorded Invocations were called with the given arguments.
		 */
		public function neverCalledWith(...args):Boolean
		{
			return !arrayMatchesAny(arguments, new ArgumentsMatcher(args));
		}
		
		/**
		 * Checks if any of the recorded Invocations threw an error, 
		 * optionally checking if it matches the given Error or Matcher.
		 */
		public function threw(errorOrMatcher:Object = null):Boolean
		{
			return errorOrMatcher
				? !empty(errors) && arrayMatchesAny(errors, errorOrMatcher)
				: !empty(errors);
		}
		
		/**
		 * Checks if all of the recorded Invocations threw an error, 
		 * optionally checking if it matches the given Error or Matcher.
		 */
		public function alwaysThrew(errorOrMatcher:Object = null):Boolean
		{
			return errorOrMatcher
				? !empty(errors) && arrayMatchesAll(errors, errorOrMatcher)
				: !empty(errors) && errors.length === invocations.length;
		}
		
		/**
		 * Checks if any of the recorded Invocations return the given value 
		 * or matches the given Matcher.
		 */
		public function returned(valueOrMatcher:*):Boolean
		{
			return arrayMatchesAny(returnValues, valueOrMatcher);
		}
		
		/**
		 * Checks if all of the recorded Invocations return the given value 
		 * or matches the given Matcher.
		 */
		public function alwaysReturned(valueOrMatcher:*):Boolean
		{
			return arrayMatchesAll(returnValues, valueOrMatcher);
		}

		private function arrayMatchesAny(array:Array, valueOrMatcher:*):Boolean 
		{
			return some(array, valueToMatcher(valueOrMatcher).matches);
		}

		private function arrayMatchesAll(array:Array, valueOrMatcher:*):Boolean 
		{
			return every(array, valueToMatcher(valueOrMatcher).matches);
		}
	}
}
