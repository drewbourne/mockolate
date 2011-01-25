package mockolate.issues
{
	import flash.events.Event;
	
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class Issue31_EventDispatchesTwice
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var transmitter:Issue31_ITransmitter;
		
		[Test]
		public function eventDispatchesTwice():void 
		{
			var events: Array = new Array();
			
			stub(transmitter).asEventDispatcher();
			
			transmitter.addEventListener(Event.COMPLETE, function(e:Event): void {
				events.push(e);
			});
			
			transmitter.dispatchEvent(new Event(Event.COMPLETE));
			
			assertThat(events.length, equalTo(1));
		}
	}
}