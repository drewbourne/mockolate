package mockolate
{
	import flash.events.Event;
	
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.notNullValue;

	public class UsingConstructorArgs
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(args="event1Args")]
		public var event1:Event;
		public var event1Args:Array = [ Event.COMPLETE ];

		[Mock(args="event2Args")]
		public var event2:Event;
		
		public function event2Args():Array 
		{
			return [ Event.COMPLETE ];
		}
		
		[Test]
		public function events_should_be_injected():void 
		{
			assertThat("event1", event1, notNullValue());
			assertThat("event2", event2, notNullValue());
		}
	}
}