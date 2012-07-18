package mockolate.ingredients
{
	import flash.events.Event;

	import org.hamcrest.Description;
	import org.hamcrest.StringDescription;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class ArgumentsMatcherTest
	{
		public var matcher:ArgumentsMatcher;
		public var description:Description;

		[Test]
		public function should_describeTo_description():void 
		{
			matcher = new ArgumentsMatcher([ 1, 2, 3 ]);
			description = new StringDescription();

			matcher.describeTo(description);
			assertThat(description.toString(), equalTo("<1>,<2>,<3>"));
		}

		[Test]
		public function should_describeMismatch_to_description():void 
		{
			matcher = new ArgumentsMatcher([ 1, 2, 3 ]);
			description = new StringDescription();
			
			matcher.describeMismatch([1, 3, 2], description);
			assertThat(description.toString(), equalTo("was [<1>,<3>,<2>]"));
		}

		[Test]
		public function should_coerce_args_to_matchers():void 
		{
			matcher = new ArgumentsMatcher([ 1, Event, /test/ ]);

			assertThat("should match exact values", 
				[ 1, Event, "test" ], matcher);

			assertThat("should match Event instance", 
				[ 1, new Event(Event.COMPLETE), "test" ], matcher);

			assertThat("should match RegExp", 
				[ 1, Event, "testing" ], matcher);
		}

		[Test]
		public function should_match_empty_args():void 
		{
			matcher = new ArgumentsMatcher([]);

			assertThat("should match empty args", [], matcher);
		}
	}	
}

