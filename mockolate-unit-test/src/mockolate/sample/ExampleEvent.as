package mockolate.sample
{
	import flash.events.Event;
	
	public class ExampleEvent extends Event
	{
		public function ExampleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}