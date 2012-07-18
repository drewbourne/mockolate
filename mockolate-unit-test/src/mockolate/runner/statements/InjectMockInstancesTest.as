package mockolate.runner.statements
{
	import mockolate.runner.MockolateRule;
	import mockolate.sample.ExampleClass;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.instanceOf;

	public class InjectMockInstancesTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var example:ExampleClass;

		[ProxyClass(of="example")]
		public var exampleProxy:Class;

		[Test]
		public function exampleProxy_should_be_injected_with_generated_proxy_class():void 
		{
			trace('\n\n\n');
			trace('_example', example);
			trace('_exampleProxy', exampleProxy);
			trace('\n\n\n');

			assertThat("exampleProxy should be injected", exampleProxy, not(nullValue()));
			assertThat("example should be an instance of exampleProxy Class", example, instanceOf(exampleProxy));
		}
	}
}
