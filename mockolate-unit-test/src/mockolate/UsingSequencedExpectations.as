package mockolate
{
	import flash.events.Event;
	
	import mockolate.ingredients.Sequence;
	import mockolate.sample.Flavour;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.async.Async;

	public class UsingSequencedExpectations
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var flavourA:Flavour;

		[Mock]
		public var flavourB:Flavour;
		
		[Test]
		public function mocks_in_sequence_should_pass_if_invoked_in_the_correct_sequence():void 
		{
			var seq:Sequence = sequence("should pass");
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			
			mock(flavourA).setter("ingredients").arg(["second", "third"]).once().inSequence(seq);
			mock(flavourB).method("combine").args(flavourA).once().inSequence(seq);
			
			flavourA.ingredients = ["second", "third"];
			flavourB.combine(flavourA);
		}
		
		[Test(expected="mockolate.errors.ExpectationError")]
		public function mocks_in_sequence_should_fail_if_invoked_in_the_incorrect_sequence():void 
		{
			var seq:Sequence = sequence("should fail");
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			
			mock(flavourA).setter("ingredients").arg(["second", "third"]).once().inSequence(seq);
			mock(flavourB).method("combine").args(flavourA).once().inSequence(seq);
			
			// out-of-order
			flavourB.combine(flavourA);
			flavourA.ingredients = ["second", "third"];
			
			verify(flavourA)
			verify(flavourB);
		}
	}
}