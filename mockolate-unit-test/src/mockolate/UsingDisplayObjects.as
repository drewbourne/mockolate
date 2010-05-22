package mockolate
{
	import flash.events.Event;
	
	import mockolate.runner.MockolateRunner;
	import mockolate.sample.FlavourView;
	
	import org.flexunit.async.Async;
	
	MockolateRunner;
	
	[RunWith("mockolate.runner.MockolateRunner")]
	public class UsingDisplayObjects
	{
		[Mock]
		public var view:FlavourView;
		
		[Test(async)]
		public function mockedViewsShouldDispatchEvents():void 
		{
			mock(view).method("show").dispatches(new Event("show"));
			
			Async.proceedOnEvent(this, view, "show");
			
			view.show();
		}
	}
}