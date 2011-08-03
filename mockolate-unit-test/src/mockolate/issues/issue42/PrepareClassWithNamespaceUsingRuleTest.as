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
	
	use namespace issue_namespace_1;
	use namespace issue_namespace_2;
	use namespace issue_namespace_3;

	public class PrepareClassWithNamespaceUsingRuleTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var target:ClassWithNamespaces;
		
		[Mock(namespaces="mockolate.issues.issue42.issue_namespace_1")]
		public var nsTarget:ClassWithNamespaces;
		
		[Mock(namespaces="nsTargetUsingNamespaceArrayDataProvider")]
		public var nsTargetUsingNamespaceArray:ClassWithNamespaces;
		public var nsTargetUsingNamespaceArrayDataProvider:Array 
			= [ issue_namespace_1, issue_namespace_2 ];
		
		[Mock(namespaces="nsTargetUsingNamespaceFunctionDataProvider")]
		public var nsTargetUsingNamespaceFunction:ClassWithNamespaces;
		public function nsTargetUsingNamespaceFunctionDataProvider():Array {
			return [ issue_namespace_1, issue_namespace_2, issue_namespace_3 ];
		}
		
		[Test]
		public function target_shouldNotHaveProxiedNamespacedMethods():void 
		{
			mock(target).method("isMethodProxied").returns(true);
			mock(target).nsMethod(issue_namespace_1, "isNamespacedMethodProxied").returns(true);
			
			assertThat("isMethodProxied", 
				target.isMethodProxied(), isTrue());
			
			assertThat("isNamespacedMethodProxied", 
				target.isNamespacedMethodProxied(), isFalse());
			
			assertThat("isNamespacedGetterProxied should not be proxied", 
				target.isNamespacedGetterProxied, isFalse());
			
			target.isNamespacedSetterProxied = true;
			assertThat("isNamespacedSetterProxied should not be proxied", 
				target, received().nsSetter(issue_namespace_1, "isNamespacedSetterProxied").arg(true).never());
		}
		
		[Test]
		public function nsTarget_shouldHaveProxiedNamespaceMethods():void 
		{
			mock(nsTarget).method("isMethodProxied").returns(true);
			mock(nsTarget).nsMethod(issue_namespace_1, "isNamespacedMethodProxied").returns(true);
			mock(nsTarget).nsGetter(issue_namespace_1, "isNamespacedGetterProxied").returns(true);
			
			assertThat("isMethodProxied", nsTarget.isMethodProxied(), isTrue());
			
			assertThat("isNamespacedMethodProxied", 
				nsTarget.isNamespacedMethodProxied(), isTrue());
			
			assertThat("isNamespacedGetterProxied should be proxied", 
				nsTarget.isNamespacedGetterProxied, isTrue());
			
			nsTarget.isNamespacedSetterProxied = true;
			assertThat("isNamespacedSetterProxied should be proxied", 
				nsTarget, received().nsSetter(issue_namespace_1, "isNamespacedSetterProxied").arg(true).once());
			
			target.usesIssueNamespace2 = true;
			assertThat("isNamespacedSetterProxied should not be proxied", 
				target, received().nsSetter(issue_namespace_2, "usesIssueNamespace2").arg(true).never());
			
			target.usesIssueNamespace3 = true;
			assertThat("isNamespacedSetterProxied should not be proxied", 
				target, received().nsSetter(issue_namespace_2, "usesIssueNamespace3").arg(true).never());
		}
		
		[Test]
		public function nsTargetUsingNamespaceArray_shouldHaveProxiedNamespaceMethods():void 
		{
			mock(nsTargetUsingNamespaceArray).method("isMethodProxied").returns(true);
			mock(nsTargetUsingNamespaceArray).nsMethod(issue_namespace_1, "isNamespacedMethodProxied").returns(true);
			mock(nsTargetUsingNamespaceArray).nsGetter(issue_namespace_1, "isNamespacedGetterProxied").returns(true);
			
			assertThat("isMethodProxied", 
				nsTargetUsingNamespaceArray.isMethodProxied(), isTrue());
			
			assertThat("isNamespacedMethodProxied", 
				nsTargetUsingNamespaceArray.isNamespacedMethodProxied(), isTrue());
			
			assertThat("isNamespacedGetterProxied should be proxied", 
				nsTargetUsingNamespaceArray.isNamespacedGetterProxied, isTrue());
			
			nsTargetUsingNamespaceArray.isNamespacedSetterProxied = true;
			assertThat("isNamespacedSetterProxied should be proxied", 
				nsTargetUsingNamespaceArray, received().nsSetter(issue_namespace_1, "isNamespacedSetterProxied").arg(true).once());
			
			nsTargetUsingNamespaceArray.usesIssueNamespace2 = true;
			assertThat("usesIssueNamespace2 should be proxied", 
				nsTargetUsingNamespaceArray, received().nsSetter(issue_namespace_2, "usesIssueNamespace2").arg(true).once());
			
			nsTargetUsingNamespaceArray.usesIssueNamespace3 = true;
			assertThat("usesIssueNamespace3 should not be proxied", 
				nsTargetUsingNamespaceArray, received().nsSetter(issue_namespace_2, "usesIssueNamespace3").arg(true).never());
		}
		
		[Test]
		public function nsTargetUsingNamespaceMethod_shouldHaveProxiedNamespaceMethods():void 
		{
			nsTargetUsingNamespaceFunction.isNamespacedSetterProxied = true;
			assertThat("isNamespacedSetterProxied should be proxied", 
				nsTargetUsingNamespaceFunction, received().nsSetter(issue_namespace_1, "isNamespacedSetterProxied").arg(true).once());
			
			nsTargetUsingNamespaceFunction.usesIssueNamespace2 = true;
			assertThat("usesIssueNamespace2 should be proxied", 
				nsTargetUsingNamespaceFunction, received().nsSetter(issue_namespace_2, "usesIssueNamespace2").arg(true).once());
			
			nsTargetUsingNamespaceFunction.usesIssueNamespace3 = true;
			assertThat("usesIssueNamespace3 should be proxied", 
				nsTargetUsingNamespaceFunction, received().nsSetter(issue_namespace_3, "usesIssueNamespace3").arg(true).once());
		}
	}
}