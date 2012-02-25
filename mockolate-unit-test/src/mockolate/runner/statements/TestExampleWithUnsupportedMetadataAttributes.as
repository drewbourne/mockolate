package mockolate.runner.statements 
{
	import mockolate.sample.ExampleClass;

	public class TestExampleWithUnsupportedMetadataAttributes
	{
		[Mock]
		public var validField:ExampleClass;
		
		[Mock(unsupported="unsupported")]
		public var fieldWithUnsupportedAttribute:ExampleClass;
		
		[Mock(arggs="mispelling")]
		public var fieldWithMispelling:ExampleClass;

		[Test]
		public function unused_test():void 
		{

		}
	}	
}