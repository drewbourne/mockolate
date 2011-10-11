package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.State;
	
	public class ChangeStateAnswer implements Answer
	{
		private var _state:State;
		
		public function ChangeStateAnswer(state:State):void
		{
			_state = state;
		}
		
		public function invoke(invocation:Invocation):*
		{
			_state.activate();
		}
	}
}