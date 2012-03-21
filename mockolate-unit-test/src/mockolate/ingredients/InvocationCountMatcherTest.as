package mockolate.ingredients
{
	import org.hamcrest.Description;
	import org.hamcrest.StringDescription;
	import org.hamcrest.assertThat;
	import org.hamcrest.number.atLeast;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.core.describedAsWithMismatch;

	public class InvocationCountMatcherTest
	{
		public var matcher:InvocationCountMatcher;
		public var description:Description;

		[Test]
		public function should_describeTo_description():void 
		{
			matcher = new InvocationCountMatcher(describedAsWithMismatch("at least %0 times", "%0 times", atLeast(1), 1));
			description = new StringDescription();

			matcher.describeTo(description);
			assertThat(description.toString(), equalTo("to be invoked at least <1> times"));
		}

		[Test]
		public function should_describeMismatch_to_description():void 
		{
			matcher = new InvocationCountMatcher(describedAsWithMismatch("%0 times", "%0 times", equalTo(1), 1));
			description = new StringDescription();

			matcher.describeMismatch(2, description);
			assertThat(description.toString(), equalTo("was invoked <2> times"));
		}
	}
}