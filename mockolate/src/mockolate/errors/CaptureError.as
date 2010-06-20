package mockolate.errors
{
	import mockolate.ingredients.Capture;
	
	/**
	 * Error relating to Capture and capturing arguments. 
	 *  
	 * @author drewbourne 
	 */
	public class CaptureError extends MockolateError
	{
		private var _capture:Capture;
		
		/**
		 * Constructor. 
		 *  
		 * @param message Object
		 * @param capture
		 */
		public function CaptureError(message:Object, capture:Capture)
		{
			super(message, null, null);
			
			_capture = capture;
		}
		
		/**
		 * Capture instance this error relates to.
		 * @return Capture 
		 */
		public function get capture():Capture
		{
			return _capture;
		}
	}
}