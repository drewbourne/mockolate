package mockolate.errors
{
	import mockolate.ingredients.Capture;
	
	public class CaptureError extends MockolateError
	{
		private var _capture:Capture;
		
		public function CaptureError(message:Object, capture:Capture)
		{
			super(message, null, null);
		}
		
		public function get capture():Capture
		{
			return _capture;
		}
	}
}