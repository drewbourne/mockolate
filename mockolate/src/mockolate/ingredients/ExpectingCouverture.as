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
	public class ExpectingCouverture extends Couverture implements IMockingCouverture
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
			if (invocationHandlers[invocation.invocationType] != null)
				invocationHandlers[invocation.invocationType](invocation, args);
			
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
		 * @private
		 */
		protected function get mocker():MockingCouverture
		{
			return this.mockolate.mocker;	
		}
		
		/**
		 * @copy MockingCouverture#returns()
		 */
		public function returns(value:*, ...values):IMockingCouverture
		{
			mocker.returns.apply(null, [value].concat(values));
			return this;
		}

		/**
		 * @copy MockingCouverture#answers()
		 */
		public function answers(answer:Answer):IMockingCouverture
		{
			mocker.answers(answer);
			return this;
		}
		
		/**
		 * @copy MockingCouverture#calls()
		 */
		public function calls(fn:Function, args:Array=null):IMockingCouverture
		{
			mocker.calls(fn, args);
			return this;
		}

		/**
		 * @copy MockingCouverture#dispatches()
		 */
		public function dispatches(event:Event, delay:Number=0):IMockingCouverture
		{
			mocker.dispatches(event, delay);
			return this;
		}

		/**
		 * @copy MockingCouverture#ordered()
		 */
		public function ordered(sequence:Sequence):IMockingCouverture
		{
			mocker.ordered(sequence);
			return this;
		}

		/**
		 * @copy MockingCouverture#pass()
		 */
		public function pass():IMockingCouverture
		{
			mocker.pass();
			return this;
		}

		/**
		 * @copy MockingCouverture#throws()
		 */
		public function throws(error:Error):IMockingCouverture
		{
			mocker.throws(error)
			return this;
		}

		/**
		 * @copy MockingCouverture#times()
		 */
		public function times(n:int):IMockingCouverture
		{
			mocker.times(n);
			return this;
		}
		
		/**
		 * @copy MockingCouverture#never()
		 */
		public function never():IMockingCouverture
		{
			mocker.never();
			return this;
		}
		
		/**
		 * @copy MockingCouverture#once()
		 */
		public function once():IMockingCouverture
		{
			mocker.once();
			return this;
		}		

		/**
		 * @copy MockingCouverture#twice()
		 */
		public function twice():IMockingCouverture
		{
			mocker.twice();
			return this;
		}

		/**
		 * @copy MockingCouverture#thrice()
		 */
		public function thrice():IMockingCouverture
		{
			mocker.thrice();
			return this;
		}

		/**
		 * @copy MockingCouverture#atLeast()
		 */
		public function atLeast(n:int):IMockingCouverture
		{
			mocker.atLeast(n);
			return this;
		}
		
		/**
		 * @copy MockingCouverture#atMost()
		 */
		public function atMost(n:int):IMockingCouverture
		{
			mocker.atMost(n);
			return this;
		}
	}
}