package mockolate.mistakes
{
	import mockolate.ingredients.Mockolate;

	public class UnmetExpectationError extends MockolateError
	{
		public function UnmetExpectationError(message:String, mockolate:Mockolate, target:Object)
		{
			super(message, mockolate, target);
		}
	}
}