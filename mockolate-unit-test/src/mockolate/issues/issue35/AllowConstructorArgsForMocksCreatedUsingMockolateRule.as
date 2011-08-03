package mockolate.issues.issue35
{
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.notNullValue;

	public class AllowConstructorArgsForMocksCreatedUsingMockolateRule
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(args="target1Args")]
		public var target1:ClassWithConstructorArgs;
		public var target1Args:Array = [ true ];
		
		[Mock(args="target2Args")]
		public var target2:ClassWithConstructorArgs;
		public function target2Args():Array {
			return [ true ];
		}
		
		[Test]
		public function instancesWithConstructorArgs_shouldBeBePassedIn():void 
		{
			// see ClassWithConstructorArgs
			
			assertThat(target1, notNullValue());
			assertThat(target2, notNullValue());
		}
	}
}