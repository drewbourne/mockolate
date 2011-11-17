package mockolate
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.hamcrest.assertThat;
	
	use namespace mockolate_ingredient;

	public class UsingMockolateThroughMockolateRule
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var mockolatier:Mockolatier;
		
		[Mock]
		public var flavour:Flavour;

		[Before]
		public function setup():void 
		{
			// MockolateRule defaults to using the MockolatierMaster.mockolatier
			// however we can override the mockolatier that the rule uses.
			mocks.mockolatier = mockolatier;
		}
		
		[Test]
		public function prepare_shouldBeForwardedToMockolatier():void 
		{
			mocks.prepare(EventDispatcher, Sprite);
			
			assertThat(mockolatier, received().method("prepare").args(EventDispatcher, Sprite).once());
		}
		
		[Ignore("TODO update for prepareInstance")]
		[Test]
		public function nice_shouldBeForwardedToMockolatier():void 
		{
			mocks.nice(Flavour);
			assertThat('mocks.nice<[Flavour]>', 
				mockolatier, received().method("nice").args(Flavour, null, null).once());
			
			mocks.nice(Flavour, "niceFlavour");
			assertThat('mocks.nice<[Flavour, "niceFlavour"]>', 
				mockolatier, received().method("nice").args(Flavour, "niceFlavour", null).once());
			
			var constructorArgs:Array = [];
			mocks.nice(Flavour, "niceFlavour", constructorArgs);
			assertThat('mocks.nice<[Flavour, "niceFlavour", constructorArgs]>', 
				mockolatier, received().method("nice").args(Flavour, "niceFlavour", constructorArgs).once());
		}
		
		[Ignore("TODO update for prepareInstance")]
		[Test]
		public function strict_shouldBeForwardedToMockolatier():void 
		{
			mocks.strict(Flavour);
			assertThat(mockolatier, received().method("strict").args(Flavour, null, null).once());
			
			mocks.strict(Flavour, "strictFlavour");
			assertThat(mockolatier, received().method("strict").args(Flavour, "strictFlavour", null).once());
			
			var constructorArgs:Array = [];
			mocks.strict(Flavour, "strictFlavour", constructorArgs);
			assertThat(mockolatier, received().method("strict").args(Flavour, "strictFlavour", constructorArgs).once());
		}
		
		[Ignore("TODO update for prepareInstance")]
		[Test]
		public function partial_shouldBeForwardedToMockolatier():void 
		{
			mocks.partial(Flavour);
			assertThat("mocks.partial<[Flavour]>", 
				mockolatier, received().method("partial").args(Flavour, null, null).once());
			
			mocks.partial(Flavour, "partialFlavour");
			assertThat('mocks.partial<[Flavour, "partialFlavour"]>', 
				mockolatier, received().method("partial").args(Flavour, "partialFlavour", null).once());
			
			var constructorArgs:Array = [];
			mocks.partial(Flavour, "partialFlavour", constructorArgs);
			assertThat('mocks.partial<[Flavour, "partialFlavour", constructorArgs]>', 
				mockolatier, received().method("partial").args(Flavour, "partialFlavour", constructorArgs).once());
		}
		
//		[Ignore]
		[Test]
		public function mock_shouldBeForwardedToMockolatier():void
		{
			mocks.mock(Flavour);
			
			assertThat(mockolatier, received().method("mock").args(Flavour).once());
		}
		
		[Test]
		public function stub_shouldBeForwardedToMockolatier():void
		{
			mocks.stub(Flavour);
			
			assertThat(mockolatier, received().method("stub").args(Flavour).once());
		}
		
		[Test]
		public function verify_shouldBeForwardedToMockolatier():void
		{
			mocks.verify(flavour);
			
			assertThat(mockolatier, received().method("verify").args(flavour).once());
		}
		
		[Test]
		public function expect_arg_shouldBeForwardedToMockolatier():void
		{
			mocks.expect(flavour.combine(mocks.arg(Flavour)));
			
			assertThat(mockolatier, received().method("expectArg").args(Flavour).once());
			assertThat(mockolatier, received().method("expect").args(null).once());
		}
		
		[Test]
		public function expecting_shouldBeForwardedToMockolatier():void
		{
			var context:Function = function():void {
				mocks.expect(flavour.combine(mocks.arg(Flavour)));
			};
			
			mocks.expecting(context);
			
			assertThat(mockolatier, received().method("expecting").args(context).once());
		}
	}
}