package mockolate.ingredients
{
	import org.hamcrest.BaseMatcher;
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	
	/**
	 * Matcher for use as an argument matcher that captures the matched item 
	 * to a Capture instance.
	 * 
	 * @see mockolate#capture()
	 * @see mockolate.ingredients.Capture
	 *  
	 * @author drewbourne
	 */
	public class CaptureMatcher extends BaseMatcher
	{
		private var _capture:Capture;
		
		/**
		 * Constructor.
		 * @param capture
		 */
		public function CaptureMatcher(capture:Capture)
		{
			super();
			
			_capture = capture;
			
		}
		
		/**
		 * Captures the given item to the Capture instance.
		 * 
		 * @param item
		 * @return <code>true</code>
		 */
		override public function matches(item:Object):Boolean
		{
			_capture.value = item;
			
			return true;
		}
		
		/**
		 * @private
		 */
		override public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
			// CaptureMatcher never mismatches.
		}
		
		/**
		 * @private
		 */		
		override public function describeTo(description:Description):void
		{
			description
				.appendText("captured values ")
				.appendValue(_capture.values);
		}
	}
}