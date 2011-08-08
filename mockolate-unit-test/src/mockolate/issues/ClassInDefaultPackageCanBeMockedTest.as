package mockolate.issues
{
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;

	public class ClassInDefaultPackageCanBeMockedTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
	
		[Mock(inject=false)]	
		public var instance:ClassInDefaultPackageCanBeMocked;
		
		[Test]
		public function ohYesItCanNow():void 
		{
			instance = strict(ClassInDefaultPackageCanBeMocked);
			
			assertThat(instance.calledSuper, isFalse());
			
			mock(instance).method("attemptToMockMethod").once();
			instance.attemptToMockMethod();
			assertThat(instance.calledSuper, isFalse());
		}
	}
}