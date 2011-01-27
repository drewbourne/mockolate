package mockolate.ingredients
{
	/**
	 * Used to indicate the behaviour of a Mockolate instance when an Expectation
	 * is not defined for an Invocation.
	 * 
	 * @author drewbourne 
	 */
	public class MockType
	{
		/**
		 * When a Mockolate is 'nice' it will return false-y values for any method 
     	 * or property that does not have a <code>mock()</code> or 
     	 * <code>stub()</code> Expectation defined. 
		 */
		public static const NICE:MockType = new MockType("nice");
		
		/**
	     * When a Mockolate is 'strict' it will throw an UnspecifiedBehaviourError
	     * for any method or property that does not have a <code>mock()</code> or
	     * <code>stub()</code> Expectation defined. 
		 */
		public static const STRICT:MockType = new MockType("strict");
		
		/**
		 * When a Mockolate is 'partial' it will call the superclass method or 
		 * property when there is not a <code>mock()</code> or 
		 * <code>stub()</code> Expectation defined.
		 */
		public static const PARTIAL:MockType = new MockType("partial");
		
		/**
		 * Array of supported MockType.
		 */
		public static function get values():Array 
		{
			return [ NICE, STRICT, PARTIAL ];
		}
		
		/**
		 * Converts a String to the MockType. 
		 */
		public static function enumFor(value:String):MockType
		{
			return MockType[value.toUpperCase()];
		}
		
		/** Constructor */
		public function MockType(name:String)
		{
			_name = name;
		}
		
		/** Converts the MockType to a String */
		public function toString():String 
		{
			return _name;
		}
		
		private var _name:String;
	}
}