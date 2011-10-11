package mockolate.ingredients
{
	public interface StatesCouverture
	{
		function isStateOf(name:String):State;
		
		function isNot(name:String):StatePredicate;
	}
}