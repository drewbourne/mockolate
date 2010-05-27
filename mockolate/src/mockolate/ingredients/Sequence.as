package mockolate.ingredients
{
	import asx.array.every;
	import asx.fn.getProperty;
	
	import mockolate.ingredients.constraints.InSequenceOrderingConstraint;

	/**
	 * Sequence
	 *  
	 * @author drewbourne
	 */
	public class Sequence
	{
		/**
		 * Constructor
		 * 
		 * @param name
		 */
		public function Sequence(name:String = null)
		{
			super();
			
			_name = name;
			_expectations = [];
		}
		
		/**
		 * Name of this Sequence
		 */
		public function get name():String
		{
			return _name;
		}
		
		private var _name:String;
		
		[ArrayElementType("mockolate.ingredients.Expectation")]
		/**
		 * Array of Expectations in this Sequence
		 */
		public function get expectations():Array
		{
			return _expectations;
		}
		
		private var _expectations:Array;
		
		/**
		 * 
		 */
		public function constrainAsNextInSequence(expectation:Expectation):Expectation 
		{
			var index:int = _expectations.length;
			
			_expectations[index] = expectation;
			
			expectation.addConstraint(new InSequenceOrderingConstraint(this, index));
			
			return expectation;
		}
		
		/**
		 * 
		 */
		public function satisfiedToIndex(index:int):Boolean 
		{
			return every(_expectations.slice(0, index), getProperty('satisfied')); 
		}
	}
}