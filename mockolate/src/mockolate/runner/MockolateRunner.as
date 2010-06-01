package mockolate.runner
{
	import asx.array.compact;
	import asx.array.pluck;
	import asx.array.unique;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	
	import mockolate.runner.statements.IdentifyMockClasses;
	import mockolate.runner.statements.InjectMockInstances;
	import mockolate.runner.statements.PrepareMockClasses;
	import mockolate.runner.statements.VerifyMockInstances;
	
	import org.flexunit.internals.runners.InitializationError;
	import org.flexunit.internals.runners.statements.Fail;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.RunBeforesClass;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.runners.BlockFlexUnit4ClassRunner;
	import org.flexunit.runners.model.FrameworkMethod;

	public class MockolateRunner extends BlockFlexUnit4ClassRunner
	{
		protected var sequence:StatementSequencer;
		protected var data:MockolateRunnerData;

		public function MockolateRunner(klass:Class)
		{
			super(klass);
		}

		protected override function methodBlock(method:FrameworkMethod):IAsyncStatement
		{
			//COPY/PASTE FROM PARENT to supplement runner until refactor

			var test:Object;

			//might need to be reflective at some point
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
			
			sequence.addStep(withBefores(method, test));
			sequence.addStep(withDecoration(method, test));
			sequence.addStep(withAfters(method, test));			
			
			sequence.addStep(new VerifyMockInstances(data));

			return sequence;
		}
	}
}