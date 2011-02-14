package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;
	
	use namespace mockolate_ingredient;

	/**
	 * Proxies calls to the MockingCouverture
	 * 
	 * @author drewbourne
	 */
	public class MockingCouvertureProxy extends Couverture implements IMockingCouverture
	{
		/**
		 * Constructor.
		 * 
		 * @param mockolate
		 */
		public function MockingCouvertureProxy(mockolate:Mockolate)
		{
			super(mockolate);
		}
		
		/**
		 * @private
		 */
		protected function get mocker():MockingCouverture
		{
			return this.mockolateInstance.mocker;	
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
		 * @copy MockingCouverture#callsWithInvocation()
		 */
		public function callsWithInvocation(fn:Function, args:Array=null):IMockingCouverture
		{
			mocker.callsWithInvocation(fn, args);
			return this;
		}
		
		/**
		 * @copy MockingCouverture#callsWithArguments()
		 */
		public function callsWithArguments(fn:Function, args:Array=null):IMockingCouverture
		{
			mocker.callsWithArguments(fn, args);
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
		 * @copy MockingCouverture#callsSuper()
		 */
		public function callsSuper():IMockingCouverture
		{
			mocker.callsSuper();
			return this;
		}
		
		/**
		 * @copy MockingCouverture#pass()
		 */
		public function pass():IMockingCouverture
		{
			return callsSuper();
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