package mockolate
{
	import mockolate.decorations.rpc.StubbingHttpService;
	import mockolate.ingredients.*;
	import mockolate.ingredients.floxy.InterceptingCouvertureTest;
	import mockolate.ingredients.proxy.ProxyMockolateTest;
	import mockolate.issues.ClassInDefaultPackageCannotBeMockedTest;
	import mockolate.issues.FunctionApplyTest;
	import mockolate.issues.Issue29_IncorrectCountInTestSpy;
	import mockolate.issues.Issue31_EventDispatchesTwice;
	import mockolate.issues.Issue33_DefaultInvocationCount;
	import mockolate.issues.IssueXX_NeverNotFailing;
	import mockolate.issues.MockingClassWithConstructorGetter;
	import mockolate.runner.MockolateRuleExample;
	import mockolate.runner.MockolateRunnerExample;

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
		
		// 
		//	decorators
		//
		public var stubbingHTTPService:StubbingHttpService;		
      
		//
        // 	runner
		//
        public var runnerExample:MockolateRunnerExample;
		public var ruleExample:MockolateRuleExample;
		
		//
		//	issues
		//
		public var mockingClassWithConstructorGetter:MockingClassWithConstructorGetter;
		public var classInDefaultPackageCannotBeMocked:ClassInDefaultPackageCannotBeMockedTest;
		public var functionApply:FunctionApplyTest;
		public var issue29_IncorrectCountInTestSpy:Issue29_IncorrectCountInTestSpy;
		public var issue31_EventDispatchesTwice:Issue31_EventDispatchesTwice;
		public var issue33_DefaultInvocationCount:Issue33_DefaultInvocationCount;
	}
}