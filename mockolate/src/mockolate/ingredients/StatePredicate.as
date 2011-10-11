package mockolate.ingredients
{
	import org.hamcrest.SelfDescribing;

	public interface StatePredicate extends SelfDescribing
	{
		function isActive():Boolean;
	}
}