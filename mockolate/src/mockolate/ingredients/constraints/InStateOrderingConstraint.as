package mockolate.ingredients.constraints
{
	import mockolate.ingredients.StatePredicate;
	
	import org.hamcrest.Description;
	
	public class InStateOrderingConstraint implements Constraint
	{
		private var _statePredicate:StatePredicate;
		
		public function InStateOrderingConstraint(statePredicate:StatePredicate)
		{
			_statePredicate = statePredicate;
		}
		
		public function isInvocationAllowed():Boolean
		{
			return _statePredicate.isActive();
		}
		
		public function describeTo(description:Description):void 
		{
			description.appendText("when ");
			_statePredicate.describeTo(description);
		}
	}
}