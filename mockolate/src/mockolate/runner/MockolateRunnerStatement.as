package mockolate.runner
{
	import org.flexunit.internals.runners.statements.AsyncStatementBase;
	
	/**
	 * Base Class for IAsyncStatements used by the MockolateRunner 
	 * and MockolateRule.  
	 * 
	 * @author drewbourne
	 */
	public class MockolateRunnerStatement extends AsyncStatementBase
	{
		/**
		 * MockolateRunnerData
		 */
		public var data:MockolateRunnerData;
		
		/**
		 * Constructor.
		 *  
		 * @param data
		 */
		public function MockolateRunnerStatement(data:MockolateRunnerData)
		{
			super();
			
			this.data = data;
		}
	}
}