package mockolate.mistakes
{
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.Mockolate;

	public class UnexpectedBehaviourError extends MockolateError
	{
		public function UnexpectedBehaviourError(mockolate:Mockolate, target:Object, invocation:Invocation) 
		{
			super("Unexpected Behaviour", mockolate, target);
			
			_invocation = invocation;
		}

		private var _invocation:Invocation;
		
		public function get invocation():Invocation 
		{
			return _invocation;
		}
	}
}