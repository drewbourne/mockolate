package mockolate.runner
{
	import org.flexunit.runners.model.FrameworkMethod;

	public class MockolateRunnerData
	{
		public var test:Object;
		public var method:FrameworkMethod;
		
		[ArrayElementType("mockolate.runner.MockMetadata")]
		public var mockMetadatas:Array;
		
		[ArrayElementType("Object")]
		public var mockInstances:Array;		
	}
}