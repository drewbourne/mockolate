package mockolate.ingredients.constraints
{
	import mockolate.ingredients.Sequence;

	/**
	 * Constrains an Expectation to be eligible only when invoke in the correct order. 
	 * 
	 * @see mockolate#sequence()
	 * @see mockolate.ingredients.MockingCouverture#ordered()
	 * 
	 * @author drewbourne
	 */
	public class InSequenceOrderingConstraint implements Constraint
	{
		private var _sequence:Sequence;
		private var _index:int;
		
		/**
		 * Constructor. 
		 * 
		 * @param sequence Sequence this Constraint is part of.
		 * @param index Position within the sequence the Expectation should be invoked at. 
		 */
		public function InSequenceOrderingConstraint(sequence:Sequence, index:int)
		{
			super();
			
			_sequence = sequence;
			_index = index;
		}
		
		/**
		 * Checks if the Sequence is satisfied to the index of this Constraint. 
		 */		
		public function isInvocationAllowed():Boolean
		{
			return _sequence.satisfiedToIndex(_index);
		}
	}
}