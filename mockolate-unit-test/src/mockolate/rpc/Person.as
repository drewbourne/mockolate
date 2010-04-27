package mockolate.rpc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	[Event(name="created", type="flash.events.Event")]
	[Event(name="updated", type="flash.events.Event")]
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	public class Person extends EventDispatcher
	{
		public static const CREATED : String = "created";
		public static const UPDATED : String = "updated";
		
		//dependencies
		public var service : HTTPService;
		
		//data members
		public var id : Number = -1;
		public var name : String;
		public var phone : String;
		
		public function Person()
		{
		}
		
		public function save() : void
		{
			//Set the method to POST for RESTful create or update
			service.method = "POST";
			
			//if no id is defined, we must be updating, so let the RESTful service know this should really be a PUT
			if(id != -1)
			{
				service.headers = { "X-Method-Override" : "PUT" };
			}
			
			//make service call
			var token : AsyncToken = service.send({id: id, name: name, phone: phone});
			token.addResponder(new Responder(onSaveResult, onSaveFault));
		}
		
		protected function onSaveResult(event : ResultEvent) : void
		{
			//if id is empty, then it must have been a create
			if(id == -1)
			{
				id = event.result as Number;
				dispatchEvent(new Event("created"));
			}
				//id is already populated, so it must have been an update
			else
			{
				dispatchEvent(new Event("updated"));
			}
		}
		
		protected function onSaveFault(event : FaultEvent) : void
		{
			dispatchEvent(event);
		}
		
		public function destroy():void 
		{
			// no-op
		}
	}
}