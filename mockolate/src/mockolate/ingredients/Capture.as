package mockolate.ingredients
{
	import mockolate.errors.CaptureError;
	
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	
	public class Capture
	{
		private var _captureType:String;
		private var _captureFunction:Function;
		private var _values:Array;
		
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
		
		public function get hasCaptured():Boolean 
		{
			return _values.length > 0;
		}
		
		public function get value():*
		{
			if (!hasCaptured)
				throw new CaptureError("Nothing captured yet.", this);
			
			return _values[0];
		}

		public function set value(value:*):void 
		{
			_captureFunction(value);			
		}
		
		public function get values():Array
		{
			return _values;
		}
		
		public function reset():void 
		{
			_values = [];
		}
		
		protected function captureAll(value:*):void 
		{
			_values[_values.length] = value;
		}
		
		protected function captureFirst(value:*):void 
		{
			if (!hasCaptured)
			{
				_values[_values.length] = value;
			}
		}
		
		protected function captureLast(value:*):void 
		{
			if (hasCaptured)
				reset();

			_values[_values.length] = value;			
		}
		
		protected function captureNone(value:*):void 
		{
			
		}
	}
}