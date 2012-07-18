package mockolate
{
	import mockolate.decorations.rpc.StubbingHttpService;
	import mockolate.ingredients.*;
	import mockolate.ingredients.bytecode.*;
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
        // mockolate ingredients
        //
        public var mockolateTest:MockolateTest;
		// BAD
		// public var mockolatier:MockolatierTest;
		public var couverture:CouvertureTest;
		public var recording:RecordingCouvertureTest;
		public var mocking:MockingCouvertureTest;
		public var expectation:ExpectationTest;
		public var classRecipe:ClassRecipeTest;
		public var classRecipes:ClassRecipesTest;
		public var classRecipeBuilder:ClassRecipeBuilderTest;
		public var instanceRecipe:InstanceRecipeTest;
		public var instancesRecipe:InstanceRecipesTest;
		public var instanceRecipeBuilder:InstanceRecipeBuilderTest;
		public var argumentsMatcher:ArgumentsMatcherTest;
		public var valueToMatcher:ValueToMatcherTest;
		public var invocationCountMatcher:InvocationCountMatcherTest;

		//
        // FLoxy integration
        //
        // public var intercepting:InterceptingCouvertureTest;
		
        //
        // examples
        //
		public var preparingMockolate:PreparingMockolates;
		public var usingNiceMockolates:UsingNiceMockolates;
		public var usingStrictMockolates:UsingStrictMockolates;
		public var usingPartialMocks:UsingPartialMocks;
		public var usingStub:StubbingMockolates;
		public var usingMock:MockingMockolates;
		public var usingVerify:VerifyingMockolates;
		public var usingTestSpies:SpyingMockolates;
		public var usingDisplayObjects:UsingDisplayObjects;
		public var usingFlashClasses:UsingFlashClasses;
		public var usingProxies:ProxyMockolateTest;
		public var usingSequencedExpectations:UsingSequencedExpectations;
		public var usingCapturedArguments:UsingCapturedArguments;
		public var usingRecordReplayExpect:UsingRecordReplayExpect;
		public var usingMockolateThroughMockolateRule:UsingMockolateThroughMockolateRule;
		public var usingAllow:UsingAllow;
		public var usingExpect:UsingExpect;
		public var usingExpecting:UsingExpecting;
		public var usingStates:UsingStates;
		public var usingSpies:UsingSpiesByInvocation;
		public var mockingRemoteObjects:MockingRemoteObjects;

		// 
		//	decorators
		//
		public var stubbingHTTPService:StubbingHttpService;
      
		//
        // 	runner
		//
		// BAD
        // public var runnerExample:MockolateRunnerExample;
		public var ruleExample:MockolateRuleExample;
		public var identifyMockClasses:IdentifyMockClassesTest;
//		public var verifyMockInstances:VerifyMockInstancesTest;
		
		//
		//	issues
		//
		/* BAD
		public var mockingClassWithConstructorGetter:MockingClassWithConstructorGetter;
		*/
		public var classInDefaultPackageCanBeMocked:ClassInDefaultPackageCanBeMockedTest;
		public var functionApply:FunctionApplyTest;
		public var issue29_IncorrectCountInTestSpy:Issue29_IncorrectCountInTestSpy;
		public var issue33_DefaultInvocationCount:Issue33_DefaultInvocationCount;
		public var issue35_AllowConstructorArgsForMocksCreatedUsingMockolateRule:AllowConstructorArgsForMocksCreatedUsingMockolateRule;
		public var issue21_NamespaceSupport:Issue21_NamespaceSupportTest;
		public var issue21_NamespaceSupport_RemoteObject:Issue21_NamespaceSupport_RemoteObjectTest;
		public var issue21_NamespaceSupport_UsingRecordReplay:Issue21_NamespaceSupport_UsingRecordReplayTest;
		/* BAD
		public var issue31_EventDispatchesTwice:Issue31_EventDispatchesTwice;
		*/
		public var issue42_ExplicityDefineNamespaceToProxy:ExplictlyDefineNamespaceToProxyTest;
		public var issue42_PrepareClassWithNamespaceUsingRule:PrepareClassWithNamespaceUsingRuleTest;
		public var usingVectors:UsingVectors;		

		// public var bytecodeTest:BytecodeProxyTest;
		public var bytecodeHatesMe:BytecodeHatesMe;
		public var bytecodeVectors:BytecodeVectors;
		public var constructors:ObjectConstructorTest;
	}
}