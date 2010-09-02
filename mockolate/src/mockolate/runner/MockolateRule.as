package mockolate.runner
{
	import mockolate.nice;
	import mockolate.runner.statements.IdentifyMockClasses;
	import mockolate.runner.statements.InjectMockInstances;
	import mockolate.runner.statements.PrepareMockClasses;
	import mockolate.runner.statements.VerifyMockInstances;
	import mockolate.strict;
	
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.MethodRuleBase;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.rules.IMethodRule;
	import org.flexunit.runners.model.FrameworkMethod;
	import org.flexunit.token.AsyncTestToken;
	
	/**
	 * MockolateRule is the recommended way to enable Mockolate support in
	 * testcases using FlexUnit 4.1 and up. 
	 * 
	 * Use [Mock] metadata to mark public vars that should be injected with a
	 * Mockolate instance.
	 * 
	 * @example
	 * <listing version="3.0">
	 *	public class UsingMockolateRuleExample 
	 * 	{
	 * 		[Rule]
	 * 		public var mockolateRule:MockolateRule = new MockolateRule();
	 * 
	 * 		[Mock]
	 * 		public var flavour:Flavour;
	 * 
	 * 		[Before]
	 * 		public function setup():void 
	 * 		{
	 * 			// flavour variable is populated with a Flavour instance
	 * 		}
	 * 
	 * 		[Test]
	 * 		public function example():void 
	 * 		{
	 * 			// perform test using flavour
	 * 		} 
	 * 	} 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public class MockolateRule extends MethodRuleBase implements IMethodRule
	{
		protected var sequence:StatementSequencer;
		protected var data:MockolateRunnerData;
		
		/**
		 * Constructor. 
		 */
		public function MockolateRule()
		{
			super();
		}
		
		/**
		 * Creates a new 'nice' Mockolate and adds it to the Mockolates that will
		 * be verified by the MockolateRule.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	public class ExtraMocks {
		 * 		[Rule]
		 * 		public var mocks:MockolateRule = new MockolateRule();
		 * 
		 * 		[Mock]
		 * 		public var flavour1:Flavour;
		 * 
		 * 		[Test]
		 * 		public function moreFlavours():void {
		 * 			var flavour2:Flavour = mocks.nice(Flavour);
		 * 			// mock() stub() f2 and it will be verified for you. 
		 * 		} 
		 * 	}
		 * </listing>
		 */
		public function nice(classReference:Class):*
		{
			var instance:* = mockolate.nice(classReference);
			this.data.mockInstances.push(instance);
			return instance;
		}
		
		/**
		 * Creates a new 'strict' Mockolate and adds it to the Mockolates that will
		 * be verified by the MockolateRule.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	public class ExtraMocks {
		 * 		[Rule]
		 * 		public var mocks:MockolateRule = new MockolateRule();
		 * 
		 * 		[Mock]
		 * 		public var flavour1:Flavour;
		 * 
		 * 		[Test]
		 * 		public function moreFlavours():void {
		 * 			var flavour2:Flavour = mocks.strict(Flavour);
		 * 			// mock() stub() flavour2 and it will be verified for you. 
		 * 		} 
		 * 	}
		 * </listing>
		 */
		public function strict(classReference:Class):* 
		{
			var instance:* = mockolate.strict(classReference);
			this.data.mockInstances.push(instance);
			return instance;
		}
		
		/**
		 * @private
		 */
		override public function apply(base:IAsyncStatement, method:FrameworkMethod, test:Object):IAsyncStatement
		{
			super.apply(base, method, test);
			
			this.data = new MockolateRunnerData();
			this.data.test = test;
			this.data.method = method;
			
			sequence = new StatementSequencer();
			sequence.addStep(new IdentifyMockClasses(data));
			sequence.addStep(new PrepareMockClasses(data));
			sequence.addStep(new InjectMockInstances(data));
			sequence.addStep(base);
			sequence.addStep(new VerifyMockInstances(data));
						
			return this;
		}
		
		/**
		 * @private
		 */
		override public function evaluate(parentToken:AsyncTestToken):void 
		{
			super.evaluate(parentToken);
			
			sequence.evaluate(myToken);
		}
		
		/**
		 * @private
		 */
		override public function toString():String
		{
			return "MockolateRule";
		}
	}
}
