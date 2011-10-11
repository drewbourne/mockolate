package mockolate.runner.statements
{
	import flash.events.Event;
	
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.Method;
	
	import mockolate.ingredients.ClassRecipes;
	import mockolate.ingredients.InstanceRecipe;
	import mockolate.ingredients.InstanceRecipes;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.anInstanceRecipe;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.runner.MockolateRunnerData;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.flexunit.runners.model.FrameworkMethod;
	import org.flexunit.token.AsyncTestToken;

	public class VerifyMockInstancesTest
	{
		[Before(async)]
		public function prepareMockolatier():void 
		{
			Async.proceedOnEvent(this, prepare(Mockolatier), Event.COMPLETE);
		}
		
		private var runnerData:MockolateRunnerData;
		private var mockolatier:Mockolatier;
		private var instanceRecipe1:InstanceRecipe;
		private var instanceRecipe2:InstanceRecipe;
		private var instanceRecipe3:InstanceRecipe;
		
		private function withRunnerData():void
		{
			instanceRecipe1 = new InstanceRecipe();
			instanceRecipe1.instance = { instance: 1 };
			instanceRecipe2 = new InstanceRecipe();
			instanceRecipe2.instance = { instance: 2 };
			instanceRecipe3 = new InstanceRecipe();
			instanceRecipe3.instance = { instance: 3 };
			
			mockolatier = nice(Mockolatier);
			
			runnerData = new MockolateRunnerData();
			runnerData.test = new TestExample();
			runnerData.mockolatier = mockolatier;
			runnerData.instanceRecipes = new InstanceRecipes();
			runnerData.instanceRecipes.add(instanceRecipe1);
			runnerData.instanceRecipes.add(instanceRecipe2);
			runnerData.instanceRecipes.add(instanceRecipe3);	
		}
		
		[Test]
		public function evaluate_should_verify_each_instanceRecipe_instance():void 
		{
			withRunnerData();
			runnerData.method = new FrameworkMethod(new Klass(TestExample).getMethod("exampleTest"));
			
			var statement:VerifyMockInstances = new VerifyMockInstances(runnerData);
			var token:AsyncTestToken = new AsyncTestToken();
			
			statement.evaluate(token);
			
			assertThat("verified instance 1", mockolatier, received().method("verify").args(instanceRecipe1.instance).once() );
			assertThat("verified instance 2", mockolatier, received().method("verify").args(instanceRecipe2.instance).once() );
			assertThat("verified instance 3", mockolatier, received().method("verify").args(instanceRecipe3.instance).once() );
		}
		
		[Test]
		public function evaluate_with_test_marked_verify_false_should_not_verify_each_instanceRecipe_instance():void 
		{
			withRunnerData();
			runnerData.method = new FrameworkMethod(new Klass(TestExample).getMethod("exampleTestWithVerifyFalse"));
			
			var statement:VerifyMockInstances = new VerifyMockInstances(runnerData);
			var token:AsyncTestToken = new AsyncTestToken();
			
			statement.evaluate(token);
			
			assertThat("verified instance 1", mockolatier, received().method("verify").args(instanceRecipe1.instance).never() );
			assertThat("verified instance 2", mockolatier, received().method("verify").args(instanceRecipe2.instance).never() );
			assertThat("verified instance 3", mockolatier, received().method("verify").args(instanceRecipe3.instance).never() );
		}
	}
}