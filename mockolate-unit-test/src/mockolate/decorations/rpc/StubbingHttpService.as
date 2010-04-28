package mockolate.decorations.rpc
{
	import flash.events.Event;
	
	import mockolate.runner.MockolateRunner; MockolateRunner;
	
	import mx.rpc.Fault;
	import mx.rpc.http.HTTPService;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.core.not;
	import org.hamcrest.object.hasProperties;
	import mx.rpc.events.FaultEvent;
	import mockolate.mock;
	
	[RunWith("mockolate.runner.MockolateRunner")]
	public class StubbingHttpService
	{	
		public static const PERSON_NAME:String = "Bob Dobalina";
		public static const PERSON_PHONE:String = "555-5555";
		
		public var person:Person;
		
		[Mock]
		public var service:HTTPService;
		
		
		[Before]
		public function setUp():void
		{
			person = new Person();
			person.service = service;
		}
		
		[Test(async)]
		public function save_withNewPerson_notifiesOfSaveAndUpdatesPerson():void 
		{
			mock(service)
				.asHTTPService()
				.method("POST")
				.send(hasProperties({ name: PERSON_NAME, phone: PERSON_PHONE }))
				.result(42);
			
			Async.handleEvent(this, person, Person.CREATED, function(event:Event, data:Object):void {
				assertThat(person.id, equalTo(42));
			});
			
			person.name = PERSON_NAME;
			person.phone = PERSON_PHONE;
			person.save();
		}
		
		[Test(async)]
		public function save_withPerson_notifiesOfSaveAndDoesntUpdatePerson():void 
		{
			mock(service)
				.asHTTPService()
				.method("POST")
				.headers({ "X-Method-Override": "PUT" })
				.send(hasProperties({ id: 87, name: PERSON_NAME, phone: PERSON_PHONE }))
				.result(87);
			
			Async.handleEvent(this, person, Person.UPDATED, function(event:Event, data:Object):void {
				assertThat(person.id, equalTo(87));
			});
			
			person.id = 87;
			person.name = PERSON_NAME;
			person.phone = PERSON_PHONE;
			person.save();
		}
		
		[Test(async)]
		public function save_withInvalidPerson_notifiesFault():void 
		{
			mock(service)
				.asHTTPService()
				.method("POST")
				.headers({ "X-Method-Override": "PUT" })
				.send(hasProperties({ name: PERSON_NAME, phone: PERSON_PHONE }))
				.fault("404", "Not Found", "No record exists for Person 42");
			
			Async.handleEvent(
				this, person, FaultEvent.FAULT, 
				function(event:FaultEvent, data:Object):void {
					assertThat(event.fault, hasProperties({ 
						faultCode: 404, 
						faultString: "Not Found", 
						faultDetail: "No record exists for Person 42" 
					}));
			});
			
			person.id = 42;
			person.name = PERSON_NAME;
			person.phone = PERSON_PHONE;
			person.save();
		}
	
		[Ignore]
		[Test(async)]
		public function destroy_withPerson_notifiesOfSaveAndDoesntUpdatePerson():void 
		{
			mock(service)
				.asHTTPService()
				.method("POST")
				.headers({ "X-Method-Override": "DELETE" })
				.send(hasProperties({ name: PERSON_NAME, phone: PERSON_PHONE }))
				.result(87);
			
			Async.handleEvent(this, person, Person.UPDATED, function(event:Event, data:Object):void {
				assertThat(person.id, equalTo(42));
			});
			
			person.id = 87;
			person.name = PERSON_NAME;
			person.phone = PERSON_PHONE;
			person.destroy();
		}
	}
}
