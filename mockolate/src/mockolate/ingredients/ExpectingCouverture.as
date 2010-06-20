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
		}
		
		/**
		 * Converts an Invocation into an Expectation by calling the appropriate 
		 * MockingCouverture methods.
		 * 
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 * @return ExpectingCouverture 
		 */
		mockolate_ingredient function expect(invocation:Invocation, args:Array):ExpectingCouverture 
		{
			if (_invocationHandlers[invocation.invocationType] != null)
				_invocationHandlers[invocation.invocationType](invocation, args);
			
			return this;
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
		 * @param args Array of arguments to set on the Expectation.
		 */
		protected function expectGetter(invocation:Invocation, args:Array):void
		{
			mocker.getter(invocation.name);
		}
		
		/**
		 * Adds a Setter Expectation.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 */
		protected function expectSetter(invocation:Invocation, args:Array):void
		{
			mocker.setter(invocation.name).arg(args[0]);
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