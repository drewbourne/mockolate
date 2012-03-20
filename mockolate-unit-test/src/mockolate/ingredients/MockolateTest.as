package mockolate.ingredients
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import mockolate.*;
	import mockolate.errors.ExpectationError;
	import mockolate.runner.MockolateRule;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.fail;
	import org.hamcrest.text.re;

	public class MockolateTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var dispatcher:IEventDispatcher;

		[Test]
		public function defining_an_expectation_from_an_invocation_should_not_record_the_invocation():void 
		{
			var event:Event = new Event(Event.COMPLETE);
			expect(dispatcher.dispatchEvent(event)).returns(true).never();

			assertThat("dispatcher should not have recorded dispatchEvent invocation", 
				dispatcher, received().method('dispatchEvent').args(event).never());
		}

		[Test]
		public function invoking_a_defined_expectation_should_be_recorded():void 
		{
			var event:Event = new Event(Event.COMPLETE);
			expect(dispatcher.dispatchEvent(event)).returns(true).once();

			dispatcher.dispatchEvent(event);

			assertThat("dispatcher should not have recorded dispatchEvent invocation", 
				dispatcher, received().method('dispatchEvent').args(event).once());
		}

		[Test(verify="false")]
		public function invoking_a_defined_expectation_more_times_than_expected_should_fail_verification():void 
		{
			var event:Event = new Event(Event.COMPLETE);
			expect(dispatcher.dispatchEvent(event)).returns(true).once();

			dispatcher.dispatchEvent(event);
			dispatcher.dispatchEvent(event);

			try
			{
				verify(dispatcher);	

				fail('expecting ExpectationError, no error thrown');
			}
			catch (error:ExpectationError)
			{
				trace(error);

				assertThat(error.message, re(/unexpected invocation/i));
				assertThat(error.message, re(/#dispatchEvent/i));
			}
		}
	}
}