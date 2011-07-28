package mockolate.issues.issue42
{
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;
	
	use namespace issue_namespace;

	public class ExplictlyDefineNamespaceToProxyTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var proxied:ClassWithNamespaces;
		
		[Mock(namespaces="flash.utils.flash_proxy,mockolate.issues.issue42.issue_namespace")]
		public var proxiedWithNamespaces:ClassWithNamespaces;
		
		[Test]
		public function proxied_shouldNotInterceptProxiedNamespaces():void 
		{
			proxied.isNamespacedMethodProxied();
			assertThat(proxied, received().nsMethod(issue_namespace, "isNamespacedMethodProxied").never());			
		}
		
		[Test]
		public function proxiedWithNamespaces_shouldInterceptProxiedNamespaces():void 
		{
			proxiedWithNamespaces.isNamespacedMethodProxied();
			assertThat(proxiedWithNamespaces, received().nsMethod(issue_namespace, "isNamespacedMethodProxied").once());
		}
	}
}