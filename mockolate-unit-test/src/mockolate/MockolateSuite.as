package mockolate
{
	import mockolate.decorations.rpc.StubbingHttpService;
	import mockolate.ingredients.*;
	import mockolate.ingredients.floxy.InterceptingCouvertureTest;
	import mockolate.ingredients.proxy.ProxyMockolateTest;
	import mockolate.issues.ClassInDefaultPackageCanBeMockedTest;
	import mockolate.issues.FunctionApplyTest;
	import mockolate.issues.Issue21_NamespaceSupportTest;
	import mockolate.issues.Issue21_NamespaceSupport_RemoteObjectTest;
	import mockolate.issues.Issue21_NamespaceSupport_UsingRecordReplayTest;
	import mockolate.issues.Issue29_IncorrectCountInTestSpy;
	import mockolate.issues.Issue31_EventDispatchesTwice;
	import mockolate.issues.Issue33_DefaultInvocationCount;
	import mockolate.issues.MockingClassWithConstructorGetter;
	import mockolate.issues.issue35.AllowConstructorArgsForMocksCreatedUsingMockolateRule;
	import mockolate.issues.issue42.ExplictlyDefineNamespaceToProxyTest;
	import mockolate.issues.issue42.PrepareClassWithNamespaceUsingRuleTest;
	import mockolate.runner.MockolateRuleExample;
	import mockolate.runner.MockolateRunnerExample;
	import mockolate.runner.statements.IdentifyMockClassesTest;
	import mockolate.runner.statements.VerifyMockInstancesTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class MockolateSuite
	{
		//
        // sandbox for testing floxy, flemit, loom, whatever
        //
//		public var sandbox:MockolateSandbox;
		
		//
        // mockolate unit tests
        //
		public var mockolatier:MockolatierTest;
		public var couverture:CouvertureTest;
		public var recording:RecordingCouvertureTest;
		public var mocking:MockingCouvertureTest;
		public var verifying:VerifyingCouvertureTest;
		
		// ingredients
		public var classRecipe:ClassRecipeTest;
		public var classRecipes:ClassRecipesTest;
		public var classRecipeBuilder:ClassRecipeBuilderTest;
		public var instanceRecipe:InstanceRecipeTest;
		public var instancesRecipe:InstanceRecipesTest;
		public var instanceRecipeBuilder:InstanceRecipeBuilderTest;

		//
        // FLoxy integration
        //
        public var intercepting:InterceptingCouvertureTest;
		
        //
        // examples
        //
		public var usingMockolate:UsingMockolate;
		public var preparingMockolate:PreparingMockolates;
		public var usingNiceMockolates:UsingNiceMockolates;
		public var usingStrictMockolates:UsingStrictMockolates;
		public var usingStub:StubbingMockolates;
		public var usingMock:MockingMockolates;
		public var usingVerify:VerifyingMockolates;
		public var usingTestSpies:SpyingMockolates;
		public var usingFlashClasses:UsingFlashClasses;
		public var usingProxies:ProxyMockolateTest;
		public var usingDisplayObjects:UsingDisplayObjects;
		public var usingOrderedExpectations:UsingOrderedExpectations;
		public var usingCapturedArguments:UsingCapturedArguments;
		public var usingRecordReplayExpect:UsingRecordReplayExpect;
		public var usingMockolateThroughMockolateRule:UsingMockolateThroughMockolateRule;
		public var usingPartialMocks:UsingPartialMocks;
		public var usingAllow:UsingAllow;
		public var usingExpect:UsingExpect;
		public var usingExpecting:UsingExpecting;
		
		// 
		//	decorators
		//
		public var stubbingHTTPService:StubbingHttpService;		
      
		//
        // 	runner
		//
        public var runnerExample:MockolateRunnerExample;
		public var ruleExample:MockolateRuleExample;
		public var identifyMockClasses:IdentifyMockClassesTest;
		public var verifyMockInstances:VerifyMockInstancesTest;
		
		//
		//	issues
		//
		public var mockingClassWithConstructorGetter:MockingClassWithConstructorGetter;
		public var classInDefaultPackageCanBeMocked:ClassInDefaultPackageCanBeMockedTest;
		public var functionApply:FunctionApplyTest;
		public var issue21_NamespaceSupport:Issue21_NamespaceSupportTest;
		public var issue21_NamespaceSupport_RemoteObject:Issue21_NamespaceSupport_RemoteObjectTest;
		public var issue21_NamespaceSupport_UsingRecordReplay:Issue21_NamespaceSupport_UsingRecordReplayTest;
		public var issue29_IncorrectCountInTestSpy:Issue29_IncorrectCountInTestSpy;
		public var issue31_EventDispatchesTwice:Issue31_EventDispatchesTwice;
		public var issue33_DefaultInvocationCount:Issue33_DefaultInvocationCount;
		public var issue35_AllowConstructorArgsForMocksCreatedUsingMockolateRule:AllowConstructorArgsForMocksCreatedUsingMockolateRule;
		public var issue42_ExplicityDefineNamespaceToProxy:ExplictlyDefineNamespaceToProxyTest;
		public var issue42_PrepareClassWithNamespaceUsingRule:PrepareClassWithNamespaceUsingRuleTest;
		public var usingVectors:UsingVectors;
	}
}