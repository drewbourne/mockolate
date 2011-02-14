package mockolate.issues
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
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
		
		[Mock]
		public var ieventDispatcher:IEventDispatcher;
		
		[Mock]
		public var eventDispatcher:EventDispatcher;
		
		[Mock]
		public var displayObject:Sprite;
		
		public function dispatchEvent_shouldOnlyBeDispatchedOnce(target:Object):void 
		{
			var events: Array = [];
			stub(target).asEventDispatcher();
			(target as IEventDispatcher).addEventListener(Event.COMPLETE, events.push);
			(target as IEventDispatcher).dispatchEvent(new Event(Event.COMPLETE));
			
			assertThat(events.length, equalTo(1));
		}
		
		[Test]
		public function dispatchEvent_shouldOnlyBeDispatchedOnce_usingTransmitter():void 
		{
			dispatchEvent_shouldOnlyBeDispatchedOnce(transmitter);
		}
		
		[Test]
		public function dispatchEvent_shouldOnlyBeDispatchedOnce_usingIEventDispatcher():void 
		{
			dispatchEvent_shouldOnlyBeDispatchedOnce(ieventDispatcher);
		}
		
		[Test]
		public function dispatchEvent_shouldOnlyBeDispatchedOnce_usingEventDispatcher():void 
		{
			dispatchEvent_shouldOnlyBeDispatchedOnce(eventDispatcher);
		}
		
		[Test]
		public function dispatchEvent_shouldOnlyBeDispatchedOnce_usingDisplayObject():void 
		{
			dispatchEvent_shouldOnlyBeDispatchedOnce(displayObject);
		}
	}
}