package mockolate.decorations
{
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.MockingCouverture;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace mockolate_ingredient;

	/**
	 * Decorator is the base Class for use with the MockingCouverture#decorate()
	 * 
	 * @see mockolate.ingredients.MockingCouverture#decorate()
	 * 
	 * @author drewbourne
	 */
	public class Decorator
	{
		private var _mockolate:Mockolate;
		private var _mocker:MockingCouverture;
		
		/**
		 * Constructor.
		 * 
		 * @param mockolate Mockolate instance
		 */
		public function Decorator(mockolate:Mockolate)
		{
			super();
			
			_mockolate = mockolate;
			_mocker = _mockolate.mocker; 			
		}
		
		/**
		 * Mockolate instance
		 */
		protected function get mockolate():Mockolate 
		{
			return _mockolate;
		}
		
		/**
		 * Shortcut to the MockingCouverture instance.
		 */
		protected function get mocker():MockingCouverture
		{
			return _mocker;
		}
		
		/**
		 * Called when a Mockolate receives an Invocation.
		 * 
		 * @param invocation 
		 */		
		mockolate_ingredient function invoked(invocation:Invocation):void
		{
			
		}
	}
}