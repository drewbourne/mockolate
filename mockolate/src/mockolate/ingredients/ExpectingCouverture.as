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
			_invocationHandlers[InvocationType.METHOD] = expectNSMethod;
			_invocationHandlers[InvocationType.GETTER] = expectNSGetter;
			_invocationHandlers[InvocationType.SETTER] = expectNSSetter;
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
			return this;
		}
		
		protected function defineExpectationFrom(invocation:Invocation, args:Array):void 
		{
			var invocationType:InvocationType = invocation.invocationType;
			var handler:Function = _invocationHandlers[invocationType];
			if (handler != null)
			{
				handler(invocation, args);
			}
		}
		
		/**
		 * Adds an Expectation for a namespaced method.
		 *  
		 * @param invocation Invocation to convert
		 * @param args Array of arguments to set on the Expectation.
		 */
		protected function expectNSMethod(invocation:Invocation, args:Array):void
		{
			// trace('ExpectingCouverture expectNSMethod name', invocation.name);
			// trace('ExpectingCouverture expectNSMethod args', args ? args.length + " " + args.join(',') : 'none');
			
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