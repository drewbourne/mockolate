package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;

	/**
	 * Common features available for mocking and stubbing.
	 * 
	 * @author drewbourne
	 */	
	public interface IMockingCouverture
	{
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
		function throws(error:Error):IMockingCouverture;

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
		function calls(fn:Function, args:Array=null):IMockingCouverture;
		
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
		function callsWithInvocation(fn:Function, args:Array=null):IMockingCouverture;
		
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
		function callsWithArguments(fn:Function, args:Array=null):IMockingCouverture;

		/**
		 * Causes the current Expectation to dispatch the given Event with an 
		 * optional delay when invoked. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("update").dispatches(new Event("updated"), 300);
		 * </listing>
		 */
		function dispatches(event:Event,delay:Number=0):IMockingCouverture;

		/**
		 * Causes the current Expectation to invoke the given Answer subclass. 
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("update").answers(new CustomAnswer());
		 * </listing>
		 */
		function answers(answer:Answer):IMockingCouverture;

		/**
		 * Sets the current Expectation to expect to be called the given 
		 * number of times. 
		 * 
		 * If the Expectation has not been invoked the correct number of times 
		 * when <code>verify()</code> is called then a	VerifyFailedError will 
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
		function times(n:int):IMockingCouverture;

		/**
		 * Sets the current Expectation to expect not to be called. 
		 * 
		 * If the Expectation has been invoked then when <code>verify()</code> 
		 * is called then a	 VerifyFailedError will be thrown.
		 * 
		 * @see #times()
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("deprecatedMethod").never();
		 * </listing>
		 */
		function never():IMockingCouverture;

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
		function once():IMockingCouverture;

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
		function twice():IMockingCouverture;

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
		function thrice():IMockingCouverture;

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
		function atLeast(n:int):IMockingCouverture;

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
		function atMost(n:int):IMockingCouverture;

		/**
		 * Sets the current Expectation to expect to be called in order.
		 * 
		 * @example
		 * <listing version="3.0">
		 *  var seq:Sequence = sequence("execution order sensitive");
		 *	mock(instance1).method("sort").ordered(seq);
		 *	mock(instance2).method("sort").ordered(seq);
		 * </listing>
		 */
		function ordered(sequence:Sequence):IMockingCouverture;

		/**
		 * Sets the current Expectation to invoke the super method or property.
		 * 
		 * @example
		 * <listing version="3.0">
		 *	mock(instance).method("addEventListener").anyArgs().callsSuper();
		 * </listing>
		 */
		function callsSuper():IMockingCouverture;		
	}
}