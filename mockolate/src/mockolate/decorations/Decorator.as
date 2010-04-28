package mockolate.decorations
{
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.MockingCouverture;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace mockolate_ingredient;

	public class Decorator
	{
		private var _mockolate:Mockolate;
		private var _mocker:MockingCouverture;
				
		public function Decorator(mockolate:Mockolate)
		{
			super();
			
			_mockolate = mockolate;
			_mocker = _mockolate.mocker; 			
		}
		
		protected function get mockolate():Mockolate 
		{
			return _mockolate;
		}
		
		protected function get mocker():MockingCouverture
		{
			return _mocker;
		}
		
		mockolate_ingredient function invoked(invocation:Invocation):void
		{
			
		}
	}
}