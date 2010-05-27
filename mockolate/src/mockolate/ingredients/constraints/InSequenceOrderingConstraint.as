package mockolate.ingredients.constraints
{
	import mockolate.ingredients.Sequence;

	public class InSequenceOrderingConstraint implements Constraint
	{
		private var _sequence:Sequence;
		private var _index:int;
		
		public function InSequenceOrderingConstraint(sequence:Sequence, index:int)
		{
			super();
			
			_sequence = sequence;
			_index = index;
		}
		
		public function isInvocationAllowed():Boolean
		{
			return _sequence.satisfiedToIndex(_index);
		}
	}
}