package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;
	
	/**
	 * Getter mocking facade to MockingCouverture.
	 * 
	 * @author drewbourne
	 */
	public class MockingGetterCouverture extends MockingCouvertureProxy implements IMockingGetterCouverture
	{
		/**
		 * Constructor.
		 * 
		 * @param mockolate
		 */
		public function MockingGetterCouverture(mockolate:Mockolate)
		{
			super(mockolate);	
		}
		
		/**
		 * @copy MockingCouverture#returns()
		 */
		public function returns(value:*, ...values):IMockingCouverture
		{
			mocker.returns.apply(mocker, [value].concat(values)); 
			return this;
		}
	}
}