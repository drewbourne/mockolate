package mockolate.mistakes
{
	import mockolate.ingredients.Mockolate;

	public class MockolateUsageError extends MockolateError
	{
		public function MockolateUsageError(message:String, mockolate:Mockolate, target:Object)
		{
			super(message, mockolate, target);
		}
		
	}
}