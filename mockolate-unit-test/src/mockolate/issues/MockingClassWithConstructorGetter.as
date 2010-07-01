package mockolate.issues
{
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.sample.ClassWithConstructorGetter;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class MockingClassWithConstructorGetter
	{
		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		
		[Mock]
		public var classWithConstructorGetter:ClassWithConstructorGetter;
		
		[Test]
		public function mockolateShouldBeAbleToMockConstructorGetter():void 
		{
			mock(classWithConstructorGetter).getter('constructor').returns(123);
			
			assertThat(classWithConstructorGetter.constructor, equalTo(123));
		}
	}
}