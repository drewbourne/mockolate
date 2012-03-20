package mockolate.ingredients
{
	import flash.events.Event;

	import org.hamcrest.Matcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	public class ValueToMatcherTest
	{
		public var matcher:Matcher;

		[Test]
		public function with_regexp():void 
		{
			var pattern:RegExp = /test/;
			var matcher:Matcher = valueToMatcher(pattern);

			assertThat("/test/", pattern, matcher);
			assertThat('"test"', "test", matcher);
			assertThat('"est"', "est", not(matcher));
		}

		[Test]
		public function with_date():void 
		{
			var now:Date = new Date();
			var same:Date = new Date(now.time);
			var then:Date = new Date(now.time - 100);

			assertThat("now", now, valueToMatcher(now));
			assertThat("same", same, valueToMatcher(now));
			assertThat("then", then, not(valueToMatcher(now)));
		}

		[Test]
		public function with_class():void 
		{
			assertThat("Class", Event, valueToMatcher(Event));
			assertThat("instance", new Event(Event.COMPLETE), valueToMatcher(Event));
			assertThat("other", {}, not(valueToMatcher(Event)));
		}

		[Test]
		public function with_matcher():void 
		{
			var matcher:Matcher = equalTo(42);
			assertThat(matcher, equalTo(matcher));
		}

		[Test]
		public function with_other_values():void 
		{
			assertThat("Boolean", true, valueToMatcher(true));
			assertThat("Boolean", false, valueToMatcher(false));
			assertThat("Number", 123, valueToMatcher(123));
			assertThat("Array", [ 1, 2, 3 ], valueToMatcher([ 1, 2, 3 ]));

			var object:Object = {};
			assertThat("Object", object, valueToMatcher(object));
		}
	}
}