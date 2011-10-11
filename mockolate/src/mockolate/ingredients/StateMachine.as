package mockolate.ingredients
{
	import org.hamcrest.Description;

	public class StateMachine implements States
	{
		internal var name:String;
		internal var currentState:String;
		
		public function StateMachine(name:String) 
		{
			this.name = name;
		}
		
		public function become(nextName:String):void
		{
			currentState = nextName;
		}
		
		public function startsAs(stateName:String):States
		{
			become(stateName);
			return this;
		}
		
		public function isStateOf(stateName:String):State
		{
			return new StateMachineState(this, stateName);
		}
		
		public function isNot(stateName:String):StatePredicate
		{
			return new StateMachineStatePredicate(this, stateName);
		}
		
		public function describeTo(description:Description):void 
		{
			description
				.appendText(name)
				.appendText(currentState == null 
					? " has no current state" 
					: (" is " + currentState));
		}
	}
}
