package mockolate.ingredients
{
	import org.hamcrest.SelfDescribing;

	public interface States extends StatesCouverture, SelfDescribing
	{
		function startsAs( initialState:String ):States;
		
		function become( nextState:String ):void;
	}
}