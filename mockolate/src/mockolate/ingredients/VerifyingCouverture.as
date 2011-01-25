package mockolate.ingredients
{
	import asx.array.empty;
	import asx.array.filter;
	import asx.array.map;
	
	import flash.utils.getQualifiedClassName;
	
	import mockolate.errors.VerificationError;
	import mockolate.received;
	
	import org.hamcrest.Description;
	import org.hamcrest.StringDescription;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.core.describedAs;
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
		private var _invocationsMatcher:InvocationsMatcher;
		private var _defaultExpectedInvocationCount:int = 1;
		
		/**
		 * Constructor.
		 */
		public function VerifyingCouverture(mockolate:Mockolate)
		{
			super(mockolate);
		}
		
		/**
		 * Sets the default expected invocation count for calls to method(), getter(), setter().
		 * 
		 * Current default is <code>1</code>.
		 * 
		 * Set to <code>0</code> to get correct results when using <code>never()</code>.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	var yum:Flavour = nice(Flavour);
		 * 	verify(yum).setDefaultExpectedInvocationCount(0);
		 * 	verify(yum).method("doNotInvoke").anyArgs().never();
		 * </listing>
		 */
		public function setDefaultExpectedInvocationCount(value:int):VerifyingCouverture
		{
			_defaultExpectedInvocationCount = value;
			return this;
		}
		
		/**
		 * Verifies if a method with the given name was invoked. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).method("toString");
		 * </listing>
		 */
		public function method(name:String/*, ns:String=null*/):VerifyingCouverture
		{
			_invocationsMatcher = received().method(name).atLeast(_defaultExpectedInvocationCount);
			doVerify();
			return this;
		}
		
		/**
		 * Verifies if a property getter with the given name was invoked. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).getter("toString");
		 * </listing>
		 */
		public function getter(name:String/*, ns:String=null*/):VerifyingCouverture
		{
			_invocationsMatcher = received().getter(name).atLeast(_defaultExpectedInvocationCount);
			doVerify();
			return this;
		}		 
		
		/**
		 * Verifies if a property setter with the given name was invoked. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).getter("toString");
		 * </listing>
		 */
		public function setter(name:String/*, ns:String=null*/):VerifyingCouverture
		{
			_invocationsMatcher = received().setter(name).atLeast(_defaultExpectedInvocationCount);
			doVerify();
			return this;
		}
		
		/**
		 * Verifies if a method or property was invoked with the given argument value. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).method("enabled").arg(true);
		 * </listing>
		 */		   
		public function arg(value:Object):VerifyingCouverture
		{
			_invocationsMatcher.arg(value);
			return args(value);
		}
		
		/**
		 * Verifies if a method or property was invoked with the given argument value. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).property("enabled").arg(true);
		 * </listing>
		 */			
		public function args(... rest):VerifyingCouverture
		{
			_invocationsMatcher.args.apply(null, rest);
			doVerify();
			return this;
		}
		
		public function noArgs():VerifyingCouverture
		{
			_invocationsMatcher.noArgs();
			doVerify();
			return this;
		}
		
		/**
		 * Verifies if a method or property was invoked the given number of times. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).property("enabled").times(2);
		 * </listing>
		 */	  
		public function times(numberOfTimes:int):VerifyingCouverture
		{
			_invocationsMatcher.times(numberOfTimes);
			doVerify();
			return this;
		}
		
		/**
		 * Verifies if a method or property was not invoked. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).property("enabled").never();
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
		 *	verify(instance).property("enabled").once();
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
		 *	verify(instance).property("enabled").twice();
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
		 *	verify(instance).property("enabled").thrice();
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
		 *	verify(instance).property("enabled").atLeast(2);
		 * </listing>
		 */
		public function atLeast(n:int):VerifyingCouverture
		{
			_invocationsMatcher.atLeast(n);
			doVerify();
			return this;
		}
		
		/**
		 * Verifies if a method or property was invoked at most the given number of times. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	verify(instance).property("enabled").atMost(2);
		 * </listing>
		 */
		public function atMost(n:int):VerifyingCouverture
		{
			_invocationsMatcher.atMost(n);
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
			if (!_invocationsMatcher.matches(this.mockolateInstance.target))
			{
				var errorDescription:StringDescription = new StringDescription();
				errorDescription
					.appendText("Expected: ")
					.appendDescriptionOf(_invocationsMatcher)
					.appendText("\n		but: ")
					.appendMismatchOf(_invocationsMatcher, this.mockolateInstance.target);
				
				throw new VerificationError(
					errorDescription.toString(), null, this.mockolateInstance, this.mockolateInstance.target);
			}			
		}
	}
}
