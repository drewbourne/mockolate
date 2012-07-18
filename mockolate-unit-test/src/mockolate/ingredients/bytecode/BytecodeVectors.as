package mockolate.ingredients.bytecode 
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import mockolate.prepare;
	import mockolate.ingredients.*;
	import mockolate.runner.*;
	import mockolate.sample.Flavour;
	import mockolate.sample.DarkChocolate;
	
	import org.flexunit.events.rule.EventRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;

	public class BytecodeVectors
	{
		[Rule]
		public var events:EventRule = new EventRule();

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var example:BytecodeVectorExample;

		[Test]
		public function should_be_able_to_proxy_vectors():void
		{
			assertThat(example, notNullValue());
		}
	}
}