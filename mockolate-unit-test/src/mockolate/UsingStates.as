package mockolate
{
	import mockolate.ingredients.States;
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Blender;
	
	import org.flexunit.assertThat;
	
	public class UsingStates
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var blender:Blender;
		
		public var power:States;
		
		[Test]
		public function using_states_should_require_invocations_when_in_correct_states():void 
		{
			power = states('power').startsAs('off');
			expect( blender.switchOn() ).then( power.isStateOf('on') ).once();
			expect( blender.blend() ).when( power.isStateOf('on') ).once();
			expect( blender.adjustSpeed( 5 ) ).when( power.isStateOf('on') ).once();
			expect( blender.switchOff() ).then( power.isStateOf('off') ).once();
			
			blender.switchOn();
			blender.blend();
			blender.adjustSpeed(5);
			blender.switchOff();
		}
		
		[Test]
		public function using_states_should_ignore_invocations_when_in_wrong_states():void 
		{
			power = states('power').startsAs('off');
			expect( blender.blend() ).when( power.isStateOf("on") ).never();
						
			blender.blend();
		}
	}
}