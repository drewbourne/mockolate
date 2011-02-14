package mockolate.issues
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;

	public class FileReferenceTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var file:FileReference;
		
		[Test]
		public function canMockFileReference():void 
		{
			assertThat(file, notNullValue());
		}
		
		[Test(async)]
		public function canDispatchEvent():void
		{
			mock(file).method("browse").anyArgs().dispatches(new Event(Event.SELECT));
			
			Async.proceedOnEvent(this, file, Event.SELECT);
			
			file.browse();
		}
	}
}