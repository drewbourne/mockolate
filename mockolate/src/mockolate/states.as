package mockolate
{
	import mockolate.ingredients.StateMachine;
	import mockolate.ingredients.States;
	
	public function states(name:String):States
	{
		return new StateMachine(name);
	}
}