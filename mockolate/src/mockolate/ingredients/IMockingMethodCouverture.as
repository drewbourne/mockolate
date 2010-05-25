package mockolate.ingredients
{
	public interface IMockingMethodCouverture extends IMockingCouverture
	{
		function args(...rest):IMockingMethodCouverture;

		function noArgs():IMockingMethodCouverture;

		function anyArgs():IMockingMethodCouverture;

		function returns(value:*, ...values):IMockingCouverture;
	}
}