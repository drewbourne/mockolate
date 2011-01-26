package mockolate.issues
{
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	
	import org.hamcrest.assertThat;

	public class Issue29_IncorrectCountInTestSpy
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var contextPart:Issue29_XMLContextPart;
		
		public var xmlPart:Issue29_XMLPart;
		
		[Test]
		public function shouldNotHaveIncorrectCountInTestSpy():void
		{
			xmlPart = new Issue29_XMLPart;
			xmlPart.context = contextPart;
			
			mock(contextPart).method("useRootNode").returns(true);
			
			xmlPart.add("var_1", "HOLA");
			xmlPart.add("var_2", "HOLA2");
			var xml:XML = xmlPart.generate();
			
			assertThat("once", contextPart, received().method("useRootNode").once());
			
			// this case was passing. it should not and does not anymore. 
			// assertThat("twice", contextPart, received().method("useRootNode").twice());
		}
	}
}