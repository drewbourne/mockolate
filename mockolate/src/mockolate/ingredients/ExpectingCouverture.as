package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;
	
	use namespace mockolate_ingredient;

	public class ExpectingCouverture extends Couverture implements IMockingCouverture
	{
		public function ExpectingCouverture(mockolate:Mockolate)
		{
			super(mockolate);
		}
		
		mockolate_ingredient function get mocker():MockingCouverture
		{
			return this.mockolate.mocker;	
		}
		
		mockolate_ingredient function expect(invocation:Invocation, args:Array):ExpectingCouverture 
		{
			if (invocation.isMethod)
			{
				mocker.method(invocation.name).args.apply(null, args);
			}
			else if (invocation.isGetter)
			{
				mocker.getter(invocation.name);
			}
			else if (invocation.isSetter)
			{
				mocker.setter(invocation.name).arg(args[0]);
			}
			
			return this;
		}
		
		public function returns(value:*, ...values):IMockingCouverture
		{
			mocker.returns.apply(null, [value].concat(values));
			return this;
		}

		public function answers(answer:Answer):IMockingCouverture
		{
			mocker.answers(answer);
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

		public function ordered(sequence:Sequence):IMockingCouverture
		{
			mocker.ordered(sequence);
			return this;
		}

		public function pass():IMockingCouverture
		{
			mocker.pass();
			return this;
		}

		public function thrice():IMockingCouverture
		{
			mocker.thrice();
			return this;
		}

		public function throws(error:Error):IMockingCouverture
		{
			mocker.throws(error)
			return this;
		}

		public function times(n:int):IMockingCouverture
		{
			mocker.times(n);
			return this;
		}

		public function twice():IMockingCouverture
		{
			mocker.twice();
			return this;
		}

	}
}