package mockolate.ingredients.bytecode
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import mockolate.prepare;
	import mockolate.ingredients.*;
	import mockolate.sample.Flavour;
	import mockolate.sample.DarkChocolate;
	
	import org.flexunit.events.rule.EventRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;

	public class BytecodeHatesMe
	{
		[Rule]
		public var events:EventRule = new EventRule();

		private function prepareThen(what:Class, then:Function):void 
		{
			var preparer:IEventDispatcher = prepare(what);

	 		preparer.addEventListener(Event.COMPLETE, function(event:Event):void {
	 			trace(what);
	 			then();
	 		});
		}

		private function prepareInOrder(classes:Array, then:Function):void 
		{
			if (classes && classes.length > 0) 
			{
				prepareThen(classes.shift(), function():void {
					prepareInOrder(classes, then);
				});
			}
			else
			{
				then();
			}
		}

		[Test(async)]
		public function all_at_once():void 
		{
			var async:EventDispatcher = new EventDispatcher();
	 		events.from(async).hasType(Event.COMPLETE).withTimeout(5000).once();	

	 		var preparer:IEventDispatcher = prepare([ IEventDispatcher, EventDispatcher, Flavour, DarkChocolate ]);
	 		preparer.addEventListener(Event.COMPLETE, function():void { 
	 			async.dispatchEvent(new Event(Event.COMPLETE)) 
	 		});
		}

	 	[Test(async)]
	 	public function lowest_to_highest():void 
	 	{
	 		var async:EventDispatcher = new EventDispatcher();
	 		events.from(async).hasType(Event.COMPLETE).withTimeout(5000).once();

	 		var classes:Array = [ IEventDispatcher, EventDispatcher, Flavour, DarkChocolate ];

	 		prepareInOrder(classes, function():void { 
	 			async.dispatchEvent(new Event(Event.COMPLETE)); 
	 		});
	 	}

	 	[Test(async)]
	 	public function highest_to_lowest():void 
	 	{
	 		var async:EventDispatcher = new EventDispatcher();
	 		events.from(async).hasType(Event.COMPLETE).withTimeout(5000).once();

	 		var classes:Array = [ DarkChocolate, Flavour, EventDispatcher, IEventDispatcher ];

	 		prepareInOrder(classes, function():void { async.dispatchEvent(new Event(Event.COMPLETE)); });
	 	}
	}	
}