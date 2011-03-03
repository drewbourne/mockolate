package mockolate.issues
{
	import flash.utils.flash_proxy;
	
	import mockolate.runner.MockolateRule;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.hasProperty;

	public class Issue21_NamespaceSupport_RemoteObjectTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var remoteObject:RemoteObject;
		
		public var token:AsyncToken;
		
		[Test]
		public function invokingArbitraryMethod_shouldInvokeExpectationByNamespaceAndMethodName():void 
		{
			token = new AsyncToken();
			
			// should not be invoked as namespace does not match
			mocks.mock(remoteObject)
				.method("callProperty")
				.args(hasProperties({ localName: "arbitraryMethod" }))
				.never();
			
			// should be invoked as namespace matches
			mocks.mock(remoteObject)
				.nsMethod(flash_proxy, "callProperty")
				.args(hasProperties({ localName: "arbitraryMethod" }))
				.returns(token).once();
			
			assertThat(remoteObject.arbitraryMethod(), equalTo(token));
		}
	}
}