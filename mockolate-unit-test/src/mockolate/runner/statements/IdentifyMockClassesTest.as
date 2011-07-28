package mockolate.runner.statements
{
	import mockolate.runner.MockolateRunnerData;
	import mockolate.sample.ExampleClass;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.flexunit.token.AsyncTestToken;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;

	public class IdentifyMockClassesTest
	{
		[Test]
		public function evaluate_shouldPopulateClassRecipesForEachPublicFieldMarkedWithMock():void 
		{
			var runnerData:MockolateRunnerData = new MockolateRunnerData();
			runnerData.test = new TestExample();
			
			var token:AsyncTestToken = new AsyncTestToken();
			var statement:IdentifyMockClasses = new IdentifyMockClasses(runnerData);
			
			statement.evaluate(token);
			
			assertThat("classRecipes is not null",
				runnerData.classRecipes, notNullValue());
			
			assertThat("classRecipes has 2 ClassRecipes", 
				runnerData.classRecipes.numRecipes, equalTo(2));
			
			assertThat("hasRecipeFor(ExampleClass)", 
				runnerData.classRecipes.hasRecipeFor(ExampleClass), isTrue());
			
			assertThat("hasRecipeFor(ExampleClass, [for_sample_only])", 
				runnerData.classRecipes.hasRecipeFor(ExampleClass, [for_sample_only]), isTrue());
		}
		
		[Test]
		public function evaluate_shouldPopulateInstanceRecipesForEachPublicFieldMarkedWithMock():void 
		{
			var runnerData:MockolateRunnerData = new MockolateRunnerData();
			runnerData.test = new TestExample();
			
			var token:AsyncTestToken = new AsyncTestToken();
			var statement:IdentifyMockClasses = new IdentifyMockClasses(runnerData);
			
			statement.evaluate(token);
			
			assertThat("instanceRecipes is not null",
				runnerData.instanceRecipes, notNullValue());
			
			assertThat("instanceRecipes has 7 InstanceRecipes", 
				runnerData.instanceRecipes.numRecipes, equalTo(7));
		}
	}
}