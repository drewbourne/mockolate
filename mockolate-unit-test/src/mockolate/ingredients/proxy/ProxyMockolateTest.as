package mockolate.ingredients.proxy
{
	import mockolate.sample.Example;
	import mockolate.stub;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class ProxyMockolateTest
	{	
		public var proxy:MockolateProxy;
		public var example:ExampleMock;
		
		[Before]
		public function setUp():void
		{
			example = new ExampleMock();
		}
		
		[Test]
		public function stubs():void 
		{
			stub(example).method("giveString").returns("HELLO").once();
			
			assertThat(example.giveString(), equalTo("HELLO"));
		}		
	}
}
