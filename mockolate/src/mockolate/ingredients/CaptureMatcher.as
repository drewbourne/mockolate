package mockolate.ingredients
{
	import org.hamcrest.BaseMatcher;
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	
	public class CaptureMatcher extends BaseMatcher
	{
		private var _capture:Capture;
		
		public function CaptureMatcher(capture:Capture)
		{
			super();
			
			_capture = capture;
			
		}
		
		override public function matches(item:Object):Boolean
		{
			_capture.value = item;
			
			return true;
		}
		
		override public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
		}
		
		override public function describeTo(description:Description):void
		{
			description
				.appendText("captured values ")
				.appendValue(_capture.values);
		}
	}
}