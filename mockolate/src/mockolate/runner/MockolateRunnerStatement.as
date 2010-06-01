package mockolate.runner
{
	import org.flexunit.internals.runners.statements.AsyncStatementBase;
	
	public class MockolateRunnerStatement extends AsyncStatementBase
	{
		public var data:MockolateRunnerData;
		
		public function MockolateRunnerStatement(data:MockolateRunnerData)
		{
			super();
			
			this.data = data;
		}
	}
}