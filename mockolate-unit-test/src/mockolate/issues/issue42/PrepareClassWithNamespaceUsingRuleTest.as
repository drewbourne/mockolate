package mockolate.issues.issue42
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.prepareClassWithNamespaces;
	import mockolate.preparedClassFor;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	
	use namespace issue_namespace;

	public class PrepareClassWithNamespaceUsingRuleTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var target:ClassWithNamespaces;
		
		[Mock(namespaces="mockolate.issues.issue42.issue_namespace")]
		public var nsTarget:ClassWithNamespaces;
		
		[Test]
		public function target_shouldNotHaveProxiedNamespacedMethods():void 
		{
			mock(target).method("isMethodProxied").returns(true);
			mock(target).nsMethod(issue_namespace, "isNamespacedMethodProxied").returns(true);
			
			assertThat("isMethodProxied", 
				target.isMethodProxied(), isTrue());
			
			assertThat("isNamespacedMethodProxied", 
				target.isNamespacedMethodProxied(), isFalse());
			
			assertThat("isNamespacedGetterProxied should not be proxied", 
				target.isNamespacedGetterProxied, isFalse());
			
			target.isNamespacedSetterProxied = true;
			assertThat("isNamespacedSetterProxied should not be proxied", 
				target, received().nsSetter(issue_namespace, "isNamespacedSetterProxied").arg(true).never());
		}
		
		[Test]
		public function nsTarget_shouldHaveProxiedNamespaceMethods():void 
		{
			mock(nsTarget).method("isMethodProxied").returns(true);
			mock(nsTarget).nsMethod(issue_namespace, "isNamespacedMethodProxied").returns(true);
			mock(nsTarget).nsGetter(issue_namespace, "isNamespacedGetterProxied").returns(true);
			
			assertThat("isMethodProxied", nsTarget.isMethodProxied(), isTrue());
			
			assertThat("isNamespacedMethodProxied", 
				nsTarget.isNamespacedMethodProxied(), isTrue());
			
			assertThat("isNamespacedGetterProxied should be proxied", 
				nsTarget.isNamespacedGetterProxied, isTrue());
			
			nsTarget.isNamespacedSetterProxied = true;
			assertThat("isNamespacedSetterProxied should be proxied", 
				nsTarget, received().nsSetter(issue_namespace, "isNamespacedSetterProxied").arg(true).once());
		}
	}
}