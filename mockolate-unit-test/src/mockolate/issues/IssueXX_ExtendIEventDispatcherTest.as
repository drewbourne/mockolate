package mockolate.issues
{
	import flash.events.Event;
	
	import mockolate.decorations.EventDispatcherDecorator;
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	
	import org.flexunit.async.Async;

	public class IssueXX_ExtendIEventDispatcherTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

//			mock(dispatcher).decorate(IssueXX_ExtendsIEventDispatcher_ExtenededInterface, EventDispatcherDecorator);
		
		[Mock(type="strict",inject="false")]
		public var dispatcher:IssueXX_ExtendsIEventDispatcher_ExtenededInterface;
		
		[Test(async)]
		public function test(): void
		{
			dispatcher = strict(IssueXX_ExtendsIEventDispatcher_ExtenededInterface);
			mock(dispatcher).asEventDispatcher();
			mock(dispatcher).method("load").dispatches(new Event(Event.OPEN));
			dispatcher.addEventListener(Event.OPEN, testHandler);
			dispatcher.load();
		}
		
		private function testHandler(event:Event):void
		{
			trace("testHandler()");
		}
	}
}