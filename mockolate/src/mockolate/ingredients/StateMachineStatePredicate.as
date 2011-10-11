package mockolate.ingredients
{
	import org.hamcrest.Description;

	internal class StateMachineStatePredicate implements StatePredicate 
	{
		private var _stateMachine:StateMachine;
		private var _stateName:String
		
		public function StateMachineStatePredicate(stateMachine:StateMachine, stateName:String)
		{
			_stateMachine = stateMachine;
			_stateName = stateName;
		}
		
		public function isActive():Boolean {
			return _stateName != _stateMachine.currentState;
		}
		
		public function describeTo(description:Description):void 
		{
			description
				.appendText(_stateName)
				.appendText(" is not ")
				.appendText(_stateMachine.currentState);		
		}
	}
}