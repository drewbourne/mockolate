package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;

	public interface IMockingCouverture
	{
		function throws(error:Error):IMockingCouverture;

		function calls(fn:Function,args:Array=null):IMockingCouverture;

		function dispatches(event:Event,delay:Number=0):IMockingCouverture;

		function answers(answer:Answer):IMockingCouverture;

		function times(n:int):IMockingCouverture;

		function never():IMockingCouverture;

		function once():IMockingCouverture;

		function twice():IMockingCouverture;

		function thrice():IMockingCouverture;

		function atLeast(n:int):IMockingCouverture;

		function atMost(n:int):IMockingCouverture;

		function ordered(sequence:Sequence):IMockingCouverture;

		function pass():IMockingCouverture;
	}
}