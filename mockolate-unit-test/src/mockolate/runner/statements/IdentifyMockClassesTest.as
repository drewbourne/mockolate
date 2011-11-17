package mockolate.runner.statements
{
	import flash.events.Event;
	
	import mockolate.arg;
	import mockolate.expect;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.sample.ExampleClass;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.flexunit.token.AsyncTestToken;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	
	use namespace mockolate_ingredient;

	public class IdentifyMockClassesTest
	{
		[Before(async)]
		public function prepareMockolatier():void 
		{
			Async.proceedOnEvent(this, prepare(Mockolatier), Event.COMPLETE);
		}
		
		private var mockolatier:Mockolatier;
		
		private function withMockolatier():void 
		{
			mockolatier = nice(Mockolatier);
			expect(mockolatier.preparedClassRecipeFor(arg(anything()), arg(anything()))).returns(null);
		}
		
		[Test]
		public function evaluate_shouldPopulateClassRecipesForEachPublicFieldMarkedWithMock():void 
		{
			withMockolatier();
			
			var runnerData:MockolateRunnerData = new MockolateRunnerData();
			runnerData.test = new TestExample();
			runnerData.mockolatier = mockolatier;
			
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
			withMockolatier();
			
			var runnerData:MockolateRunnerData = new MockolateRunnerData();
			runnerData.test = new TestExample();
			runnerData.mockolatier = mockolatier;
			
			var token:AsyncTestToken = new AsyncTestToken();
			var statement:IdentifyMockClasses = new IdentifyMockClasses(runnerData);
			
			statement.evaluate(token);
			
			assertThat("instanceRecipes is not null",
				runnerData.instanceRecipes, notNullValue());
			
			assertThat('instanceRecipes has 6 InstanceRecipes, one for each [Mock] field that is not [Mock(inject="false")]', 
				runnerData.instanceRecipes.numRecipes, equalTo(6));
		}
	}
}