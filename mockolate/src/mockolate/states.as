package mockolate
{
	import mockolate.ingredients.StateMachine;
	import mockolate.ingredients.States;

	/**
	 * Creates a StateMachine to constrain Expectations to be eligible 
	 * when the StateMachine is (or is not) in a specific state.  
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	power = states('power').startsAs('off');
	 * 	blender = nice(Blender);
	 * 
	 * 	expect( blender.switchOn() ).then( power.isStateOf('on') ).once();
	 * 	expect( blender.blend() ).when( power.isNot('on') ).never();
	 * 	expect( blender.blend() ).when( power.isStateOf('on') ).once();
	 * 	expect( blender.switchOff() ).then( power.isStateOf('off') ).once():
	 * </listing>
	 */
	public function states(name:String):States
	{
		return new StateMachine(name);
	}
}