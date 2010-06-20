package mockolate.runner
{
	import org.flexunit.runners.model.FrameworkMethod;

	/**
	 * ValueObject for data used by the MockolateRunner and MockolateRule. 
	 * 
	 * @author drewbourne
	 */	
	public class MockolateRunnerData
	{
		/**
		 * Instance of the Testcase Class currently being run.
		 */		
		public var test:Object;
		
		/**
		 * Reference to the FrameworkMethod for the current [Test]
		 */		
		public var method:FrameworkMethod;
		
		[ArrayElementType("mockolate.runner.MockMetadata")]
		/**
		 * Array of MockMetadata 
		 */
		public var mockMetadatas:Array;
		
		[ArrayElementType("Object")]
		/**
		 * Array of Mockolate targets
		 */
		public var mockInstances:Array;		
	}
}