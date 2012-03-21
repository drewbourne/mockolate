package mockolate.ingredients
{
	import org.hamcrest.Matcher;
	import org.hamcrest.BaseMatcher;
	import org.hamcrest.Description;

	public class InvocationCountMatcher extends BaseMatcher
	{
		private var _matcher:Matcher;

		public function InvocationCountMatcher(matcher:Matcher)
		{
			super();
			_matcher = matcher;
		}

		override public function matches(args:Object):Boolean 
		{
			return _matcher.matches(args);
		}

		override public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
			mismatchDescription
				.appendText("was invoked ")
				.appendMismatchOf(_matcher, item);
		}
		
		override public function describeTo(description:Description):void
		{
			description
				.appendText("to be invoked ")
				.appendDescriptionOf(_matcher);
		}
	}
}