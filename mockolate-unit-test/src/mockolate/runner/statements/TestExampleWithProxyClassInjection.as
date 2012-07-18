package mockolate.runner.statements
{
	import mockolate.sample.ExampleClass;

	public class TestExampleWithProxyClassInjection
	{
		[Mock]
		public var example:ExampleClass;

		[ProxyClass(of="example")]
		public var exampleProxy:Class;

		[Test]
		public function unused():void 
		{
		}
	}
}