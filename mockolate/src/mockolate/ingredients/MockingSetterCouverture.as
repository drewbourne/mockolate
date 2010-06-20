package mockolate.ingredients
{
	import flash.events.Event;
	
	import mockolate.ingredients.answers.Answer;
	
	/**
	 * Setter mocking facade for MockingCouverture.
	 *  
	 * @author drewbourne
	 */	
	public class MockingSetterCouverture extends MockingCouvertureProxy implements IMockingSetterCouverture
	{
		/**
		 * Constructor.
		 * 
		 * @param mockolate
		 */
		public function MockingSetterCouverture(mockolate:Mockolate)
		{
			super(mockolate);
		}
		
		/**
		 * @copy MockingCouverture#arg()
		 */
		public function arg(value:Object):IMockingSetterCouverture
		{
			mocker.arg(value);
			return this;
		}
	}
}