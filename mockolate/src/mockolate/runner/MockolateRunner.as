package mockolate.runner
{
	import mockolate.runner.statements.IdentifyMockClasses;
	import mockolate.runner.statements.InjectMockInstances;
	import mockolate.runner.statements.PrepareMockClasses;
	import mockolate.runner.statements.VerifyMockInstances;
	
	import org.flexunit.internals.runners.statements.Fail;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.runners.BlockFlexUnit4ClassRunner;
	import org.flexunit.runners.model.FrameworkMethod;

	/**
	 * MockolateRunner is the recommended way to enable Mockoate support in
	 * testcases using FlexUnit 4.0. Use MockolateRule for FlexUnit 4.1 and up.
	 * 
	 * Use [Mock] metadata to mark public vars that should be injected with a
	 * Mockolate instance.
	 * 
	 * @example
	 * <listing version="3.0">
	 * 
	 * 	import mockolate.runner.MockolateRunner; 
	 * 	MockolateRunner;
	 * 
	 * 	[RunWith("mockolate.runner.MockolateRunner")]
	 *  public class UsingMockolateRunnerExample
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
	 * @author blegros
	 */
	public class MockolateRunner extends BlockFlexUnit4ClassRunner
	{
		protected var sequence:StatementSequencer;
		protected var data:MockolateRunnerData;

		/**
		 * Constructor.
		 * 
		 * @param klass Testcase Class to run.
		 */
		public function MockolateRunner(klass:Class)
		{
			super(klass);
		}

		/**
		 * @private
		 */
		protected override function methodBlock(method:FrameworkMethod):IAsyncStatement
		{
			var test:Object;
			
			try
			{
				test = createTest();
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
				return new Fail(e);
			}
			
			this.data = new MockolateRunnerData();
			this.data.test = test;
			this.data.method = method;
			
			sequence = new StatementSequencer();
			sequence.addStep(new IdentifyMockClasses(data));
			sequence.addStep(new PrepareMockClasses(data));
			sequence.addStep(new InjectMockInstances(data));
			
			sequence.addStep(withDecoration(method, test));
			
			sequence.addStep(new VerifyMockInstances(data));
			
			return sequence;
		}
	}
}