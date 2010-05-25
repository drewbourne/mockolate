package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;
	
	public class MockingGetterCouverture implements IMockingGetterCouverture
	{
		protected var mocker:MockingCouverture;
		
		public function MockingGetterCouverture(mocker:MockingCouverture)
		{
			this.mocker = mocker;	
		}
		
		public function returns(value:*, ...values):IMockingCouverture
		{
			mocker.returns.apply(mocker, [value].concat(values)); 
			return this;
		}
		
		public function throws(error:Error):IMockingCouverture
		{
			mocker.throws(error);
			return this;
		}
		
		public function calls(fn:Function, args:Array=null):IMockingCouverture
		{
			mocker.calls(fn, args);
			return this;
		}
		
		public function dispatches(event:Event, delay:Number=0):IMockingCouverture
		{
			mocker.dispatches(event, delay);
			return this;
		}
		
		public function answers(answer:Answer):IMockingCouverture
		{
			mocker.answers(answer);
			return this;
		}
		
		public function times(n:int):IMockingCouverture
		{
			mocker.times(n);
			return this;
		}
		
		public function never():IMockingCouverture
		{
			mocker.never();
			return this;
		}
		
		public function once():IMockingCouverture
		{
			mocker.once();
			return this;
		}
		
		public function twice():IMockingCouverture
		{
			mocker.twice();
			return this;
		}
		
		public function thrice():IMockingCouverture
		{
			mocker.thrice();
			return this;
		}
		
		public function atLeast(n:int):IMockingCouverture
		{
			mocker.atLeast(n);
			return this;
		}
		
		public function atMost(n:int):IMockingCouverture
		{
			mocker.atMost(n);
			return this;
		}
		
		public function ordered(group:String=null):IMockingCouverture
		{
			mocker.ordered(group);
			return this;
		}
		
		public function pass():IMockingCouverture
		{
			mocker.pass();
			return this;
		}
	}
}