package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;
	
	use namespace mockolate_ingredient;

	/**
	 * Sets Expectations on a Mockolate by using information provided from an Invocation. 
	 * 
	 * @see mockolate.ingredients.MockingCouverture
	 * 
	 * @author drewbourne
	 */
	public class ExpectingCouverture extends MockingCouvertureProxy implements IMockingCouverture
	{
		private var _nsInvocationHandlers:Object;
		private var _invocationHandlers:Object;
		
		/**
		 * Constructor. 
		 * 
		 * @param mockolate
		 */
		public function ExpectingCouverture(mockolate:Mockolate)
		{
			super(mockolate);
			
			_invocationHandlers = {};
			_invocationHandlers[InvocationType.METHOD] = expectMethod;
			_invocationHandlers[InvocationType.GETTER] = expectGetter;
			_invocationHandlers[InvocationType.SETTER] = expectSetter;
			
			_nsInvocationHandlers = {};
			_nsInvocationHandlers[InvocationType.METHOD] = expectNSMethod;
			_nsInvocationHandlers[InvocationType.GETTER] = expectNSGetter;
			_nsInvocationHandlers[InvocationType.SETTER] = expectNSSetter;
		}
		
		/**
		 * Adds an Expectation that will not be verified.
		 * 
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 * @return ExpectingCouverture 
		 */
		mockolate_ingredient function allow(invocation:Invocation, args:Array):ExpectingCouverture 
		{
			mocker.stub();
			defineExpectationFrom(invocation, args);
			removeRecordedInvocation(invocation);
			return this;
		}
		
		/**
		 * Adds an Expectation that will be verified.
		 * 
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 * @return ExpectingCouverture 
		 */
		mockolate_ingredient function expect(invocation:Invocation, args:Array):ExpectingCouverture 
		{
			mocker.mock();
			defineExpectationFrom(invocation, args);
			removeRecordedInvocation(invocation);
			return this;
		}
		
		/**
		 * Converts an Invocation into an Expectation by calling the appropriate 
		 * MockingCouverture methods.
		 * 
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 * @return ExpectingCouverture 
		 */
		protected function removeRecordedInvocation(invocation:Invocation):void
		{
			this.mockolateInstance.recorder.removeInvocation(invocation); 
		}
		
		protected function defineExpectationFrom(invocation:Invocation, args:Array):void 
		{
			var handler:Function;
			var invocationType:InvocationType = invocation.invocationType;
			
			handler 
				= (_nsInvocationHandlers[invocationType] != null)
				? _nsInvocationHandlers[invocationType]
				: _invocationHandlers[invocationType];
			
			if (handler != null)
			{
				handler(invocation, args);
			}
		}
		
		/**
		 * Adds a Method Expectation.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 */
		protected function expectMethod(invocation:Invocation, args:Array):void
		{
			mocker.method(invocation.name).args.apply(null, args);
		}
		
		/**
		 * Adds a Getter Expectation.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Ignored.
		 */
		protected function expectGetter(invocation:Invocation, args:Array):void
		{
			mocker.getter(invocation.name);
		}
		
		/**
		 * Adds a Setter Expectation.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation. First will be used as the setter arg value.
		 */
		protected function expectSetter(invocation:Invocation, args:Array):void
		{
			mocker.setter(invocation.name).arg(args[0]);
		}
		
		/**
		 * Adds an Expectation for a namespaced method.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 */
		protected function expectNSMethod(invocation:Invocation, args:Array):void
		{
			mocker.nsMethodByNamespaceURI(invocation.uri, invocation.name).args.apply(null, args);
		}
		
		/**
		 * Adds an Expectation for a namespaced getter.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Ignored.
		 */
		protected function expectNSGetter(invocation:Invocation, args:Array):void
		{
			mocker.nsGetterByNamespaceURI(invocation.uri, invocation.name);
		}
		
		/**
		 * Adds an Expectation for a namespaced setter.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation. First will be used as the setter arg value.
		 */
		protected function expectNSSetter(invocation:Invocation, args:Array):void
		{
			mocker.nsSetterByNamespaceURI(invocation.uri, invocation.name).arg(args[0]);
		}
		
		/**
		 * @copy MockingCouverture#returns()
		 */
		public function returns(value:*, ...values):IMockingCouverture
		{
			mocker.returns.apply(null, [value].concat(values));
			return this;
		}
	}
}