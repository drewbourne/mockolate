package mockolate.ingredients
{
	import mockolate.errors.CaptureError;
	
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	
	/**
	 * Contains the captured argument values. 
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	var captured:Capture = new Capture(CaptureType.LAST);
	 * 	mock(flavour).method('combine').args(capture(captured));	
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public class Capture
	{
		private var _captureType:String;
		private var _captureFunction:Function;
		private var _values:Array;
		
		/**
		 * Constructor.
		 * 
		 * @param captureType One of 
		 * 		<code>CaptureType.ALL</code>, 
		 * 		<code>CaptureType.FIRST</code>, 
		 * 	 	<code>CaptureType.LAST</code>, 
		 * 		<code>CaptureType.NONE</code>. 
		 * 		Default is <code>CaptureType.LAST</code>.
		 */
		public function Capture(captureType:String = "last" /*CaptureType.LAST*/)
		{
			super();
			
			_captureType = captureType;
			
			var captureFunctions:Object = {};
			captureFunctions[CaptureType.ALL] = captureAll;
			captureFunctions[CaptureType.FIRST] = captureFirst;
			captureFunctions[CaptureType.LAST] = captureLast;
			captureFunctions[CaptureType.NONE] = captureNone;
			
			_captureFunction = captureFunctions[_captureType];
			
			reset();
		}
		
		/**
		 * Indicates if a value has been captured. 
		 */
		public function get hasCaptured():Boolean 
		{
			return _values.length > 0;
		}
		
		/**
		 * Get the captured value. 
		 * 
		 * @throws CaptureError if no value captured.
		 */
		public function get value():*
		{
			if (!hasCaptured)
				throw new CaptureError("Nothing captured yet.", this);
			
			return _values[0];
		}

		/**
		 * Sets the captured value.
		 * 
		 * @private
		 */
		public function set value(value:*):void 
		{
			_captureFunction(value);			
		}
		
		/**
		 * Gets the capture values.
		 */
		public function get values():Array
		{
			return _values;
		}
		
		/**
		 * Resets the capture values. 
		 */
		public function reset():void 
		{
			_values = [];
		}
		
		/**
		 * Captures a value every time.
		 * 
		 * Used for CaptureType.ALL.
		 */
		protected function captureAll(value:*):void 
		{
			_values[_values.length] = value;
		}
		
		/**
		 * Captures only the first value. 
		 * 
		 * Used for CaptureType.FIRST.
		 */
		protected function captureFirst(value:*):void 
		{
			if (!hasCaptured)
			{
				_values[_values.length] = value;
			}
		}
		
		/**
		 * Captures only the last value. 
		 * 
		 * Used for CaptureType.LAST.
		 */
		protected function captureLast(value:*):void 
		{
			if (hasCaptured)
				reset();

			_values[_values.length] = value;			
		}
		
		/**
		 * Does not capture any values.
		 * 
		 * Used for CaptureType.NONE.
		 */
		protected function captureNone(value:*):void 
		{			
		}
	}
}