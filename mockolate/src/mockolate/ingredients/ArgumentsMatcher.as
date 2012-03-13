package mockolate.ingredients
{
	import asx.array.map;

	import org.hamcrest.Matcher;
	import org.hamcrest.BaseMatcher;
	import org.hamcrest.Description;
	import org.hamcrest.collection.IsArrayMatcher;

	public class ArgumentsMatcher extends BaseMatcher
	{
		private var _args:Array;
		private var _argsMatcher:Matcher;

		public function ArgumentsMatcher(args:Array)
		{
			super();

			_args = args;
			_argsMatcher = new IsArrayMatcher(map(args, valueToMatcher));
		}

		override public function matches(args:Object):Boolean 
		{
			return _argsMatcher.matches(args);
		}

		override public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
			_argsMatcher.describeMismatch(item, mismatchDescription);
		}
		
		override public function describeTo(description:Description):void
		{
			description.appendList("", ",", "", _args);
		}
	}
}