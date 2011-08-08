package mockolate.issues
{
	import mockolate.expect;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isTrue;

	public class ClassInDefaultPackageCanBeMockedTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
	
		[Mock(inject=false)]	
		public var instance:ClassInDefaultPackageCanBeMocked;
		
		[Test]
		public function methods_shouldBeMocked():void 
		{
			instance = nice(ClassInDefaultPackageCanBeMocked);
			expect(instance.attemptToMockMethod()).returns(true).once();
			
			assertThat(instance.attemptToMockMethod(), isTrue());
		}
		
		[Test]
		public function getters_shouldBeMocked():void 
		{
			instance = nice(ClassInDefaultPackageCanBeMocked);
			expect(instance.attemptToMockGetter).returns(true).once();
			
			assertThat(instance.attemptToMockGetter, isTrue());
		}
	}
}