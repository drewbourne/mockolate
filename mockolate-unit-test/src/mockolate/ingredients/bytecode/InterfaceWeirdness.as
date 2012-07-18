package mockolate.ingredients.bytecode 
{
	import flash.events.IEventDispatcher;

	import mockolate.runner.MockolateRule;
	import mockolate.sample.*;

	public class InterfaceWeirdness
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var dispatcher:IEventDispatcher;

		[Mock]
		public var flavour:Flavour;

		[Mock]
		public var darkChocolate:DarkChocolate;

		[Test]
		public function should_create_these():void 
		{

		}
	}
}