package mockolate.flexunit
{
	import flex.lang.reflect.Constructor;
	import flex.lang.reflect.Klass;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class FlexunitKlassConstructor
	{
		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		
		[Mock]
		public var klass:Klass;
		
		[Mock]
		public var cons:Constructor;
		
		[Test]
		public function mockolateShouldBeAbleToMockKlassConstructorGetter():void 
		{
			mock(klass).getter('constructor').returns(cons);
			
			assertThat(klass.constructor, equalTo(cons));
		}
	}
}