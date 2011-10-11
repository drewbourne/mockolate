package mockolate.ingredients
{
	import org.hamcrest.Description;
	
	internal class StateMachineState implements State
	{
		private var _stateMachine:StateMachine;
		private var _stateName:String;
		
		public function StateMachineState(stateMachine:StateMachine, name:String)
		{
			_stateMachine = stateMachine;
		}
		
		public function activate():void
		{
			_stateMachine.become(_stateName);
		}
		
		public function isActive():Boolean
		{
			return _stateName == _stateMachine.currentState;
		}
		
		public function describeTo(description:Description):void
		{
			description
				.appendText(_stateMachine.name)
				.appendText(" is ")
				.appendText(_stateName);
		}
	}
}