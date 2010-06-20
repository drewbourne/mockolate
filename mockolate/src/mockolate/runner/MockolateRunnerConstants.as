package mockolate.runner
{
	/**
	 * Constants used by the MockolateRunner, and MockolateRule.
	 * 
	 * @author drewbourne
	 */
	public class MockolateRunnerConstants
	{
		// Metadata
		/**
		 * [Mock]
		 */
		public static const MOCK:String = "Mock";
		
		// Metadata attributes
		/**
		 * [Mock(type="strict")]
		 */
		public static const TYPE:String = "type";
		
		/**
		 * [Mock(inject=false)] 
		 */		
		public static const INJECT:String = "inject";
		
		/**
		 * [Mock(verify=false)]
		 */		
		public static const VERIFY:String = "verify";
	}
}