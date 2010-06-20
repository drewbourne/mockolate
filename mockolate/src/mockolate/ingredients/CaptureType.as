package mockolate.ingredients
{
	/**
	 * Determines which values a Capture instance should capture.
	 * 
	 * @see mockolate#capture()
	 * @see mockolate.ingredients.Capture
	 *  
	 * @author drewbourne
	 */
	public class CaptureType
	{
		/**
		 * Capture every value. 
		 */
		public static const ALL:String = "all";
		
		/**
		 * Capture only the first value.
		 */
		public static const FIRST:String = "first";
		
		/**
		 * Capture only the last value.
		 */
		public static const LAST:String = "last";
		
		/**
		 * Do not capture any value.
		 */
		public static const NONE:String = "none";
	}
}