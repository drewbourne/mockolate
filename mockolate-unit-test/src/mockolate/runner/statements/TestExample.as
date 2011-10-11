package mockolate.runner.statements
{
	import mockolate.sample.ExampleClass;

	public class TestExample
	{
		[Mock]
		public var example:ExampleClass;
		
		[Mock(inject="false")]
		public var exampleDontInject:ExampleClass;
		
		[Mock(type="nice")]
		public var exampleNicely:ExampleClass;
		
		[Mock(type="strict")]
		public var exampleStrictly:ExampleClass;
		
		[Mock(type="partial")]
		public var examplePartially:ExampleClass;
		
		[Mock(namespaces="mockolate.sample.for_sample_only")]
		public var exampleNamespaces:ExampleClass;
		
		[Mock(args="exampleConstructorArgs")]
		public var exampleConstructor:ExampleClass;
		public function get exampleConstructorArgs():Array 
		{
			return [1, 2, 3];
		}
		
		public var nonMockField:Boolean;
		
		[Test]
		public function exampleTest():void 
		{
		}
		
		[Test(verify="false")]
		public function exampleTestWithVerifyFalse():void 
		{
		}
	}
}