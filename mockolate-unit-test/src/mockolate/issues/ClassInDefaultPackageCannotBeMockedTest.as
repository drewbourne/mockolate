package mockolate.issues
{
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;

	public class ClassInDefaultPackageCannotBeMockedTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
	
		[Mock(inject=false)]	
		public var instance:ClassInDefaultPackageCannotBeMocked;
		
		[Test(expects="org.hamcrest.AssertionError")]
		public function ohNo():void 
		{
			instance = strict(ClassInDefaultPackageCannotBeMocked);
			
			assertThat(instance.calledSuper, isFalse());
			
			mock(instance).method("attemptToMockMethod").once();
			
			instance.attemptToMockMethod();
			
			assertThat(instance.calledSuper, isFalse());
		}
	}
}