package mockolate.runner.statements
{
	import mockolate.runner.MockolateRunnerData;
	
	import org.flexunit.token.AsyncTestToken;

	public class PrepareMockClassesTest
	{
		[Test]
		public function evaluate_should():void 
		{
			var runnerData:MockolateRunnerData = new MockolateRunnerData();
			runnerData.test = new TestExample();
			
			var token:AsyncTestToken = new AsyncTestToken();
			var statement:PrepareMockClasses = new PrepareMockClasses(runnerData);
		}
	}
}