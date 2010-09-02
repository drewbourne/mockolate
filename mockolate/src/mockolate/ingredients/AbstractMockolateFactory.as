package mockolate.ingredients
{
	/**
	 * AbstractMockolateFactory provides default factory methods for:
	 * <ul>
	 * <li>RecordingCouverture</li>
	 * <li>MockingCouverture</li>
	 * <li>VerifyingCouverture</li>
	 * <li>ExpectingCouverture</li>
	 * </ul>
	 * 
	 * @private
	 * @author drewbourne
	 */
	public class AbstractMockolateFactory
	{
		/**
		 * Constructor.
		 */
		public function AbstractMockolateFactory()
		{
			super();
		}
		
		/**
		 * @private 
		 */
		protected function createRecorder(mockolate:Mockolate):RecordingCouverture
		{
			return new RecordingCouverture(mockolate);
		}
		
		/**
		 * @private 
		 */
		protected function createMocker(mockolate:Mockolate):MockingCouverture
		{
			return new MockingCouverture(mockolate);
		}
		
		/**
		 * @private 
		 */
		protected function createVerifier(mockolate:Mockolate):VerifyingCouverture
		{
			return new VerifyingCouverture(mockolate);
		}
		
		/**
		 * @private 
		 */
		protected function createExpecter(mockolate:Mockolate):ExpectingCouverture
		{
			return new ExpectingCouverture(mockolate);
		}
	}
}