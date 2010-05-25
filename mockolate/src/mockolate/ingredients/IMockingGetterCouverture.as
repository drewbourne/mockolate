package mockolate.ingredients
{
	public interface IMockingGetterCouverture extends IMockingCouverture
	{		
		function returns(value:*, ...values):IMockingCouverture;
	}
}