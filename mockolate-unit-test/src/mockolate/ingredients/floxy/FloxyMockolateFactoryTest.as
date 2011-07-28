package mockolate.ingredients.floxy
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mockolate.ingredients.ClassRecipe;
	import mockolate.ingredients.ClassRecipes;
	import mockolate.ingredients.InstanceRecipes;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.aClassRecipe;
	import mockolate.ingredients.anInstanceRecipe;
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.sample.ExampleClass;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	
	use namespace mockolate_ingredient;

	public class FloxyMockolateFactoryTest
	{
		public var factory:FloxyMockolateFactory;
		public var mockolatier:Mockolatier;
		public var classRecipes:ClassRecipes;
		public var instanceRecipes:InstanceRecipes;
		
		[Before]
		public function setup():void 
		{
			classRecipes = new ClassRecipes();
			classRecipes.add(aClassRecipe().withClassToPrepare(ExampleClass).build());
			classRecipes.add(aClassRecipe().withClassToPrepare(ExampleClass).withNamespacesToProxy([for_sample_only]).build());
			
			instanceRecipes = new InstanceRecipes();
			instanceRecipes.add(anInstanceRecipe().withClassRecipe(classRecipes.getRecipeFor(ExampleClass)).build());
			instanceRecipes.add(anInstanceRecipe().withClassRecipe(classRecipes.getRecipeFor(ExampleClass, [for_sample_only])).build());
			
			mockolatier = new Mockolatier();
			
			factory = new FloxyMockolateFactory(mockolatier);
		}
		
		[Test(async, timeout=10000)]
		public function prepareClassRecipes_shouldNotifyCompletion():void 
		{
			var preparer:IEventDispatcher = factory.prepareClasses(classRecipes);
			
			Async.proceedOnEvent(this, preparer, Event.COMPLETE);
		}
		
		[Test(async, timeout=10000)]
		public function prepareClassRecipes_shouldSetProxyClassForEveryClassRecipe():void
		{
			var preparer:IEventDispatcher = factory.prepareClasses(classRecipes);
			
			Async.handleEvent(this, preparer, Event.COMPLETE, checkClassRecipes);
			
			function checkClassRecipes(event:Event, data:Object):void 
			{
				assertThat(classRecipes.getRecipeFor(ExampleClass).proxyClass, notNullValue());
				assertThat(classRecipes.getRecipeFor(ExampleClass).proxyClass, not(equalTo(ExampleClass)));
			}
		}
		
		[Test(async, timeout=10000)]
		public function createInstances_shouldCreateMockolateInstanceForEachInstanceRecipe():void 
		{
			var async:IEventDispatcher = new EventDispatcher();
			Async.proceedOnEvent(this, async, Event.COMPLETE, 10000);
			
			var preparer:IEventDispatcher = factory.prepareClasses(classRecipes);
			preparer.addEventListener(Event.COMPLETE, function(event:Event):void {

				var creator:IEventDispatcher = factory.prepareInstances(instanceRecipes);
				creator.addEventListener(Event.COMPLETE, checkInstances);
				
				function checkInstances(event:Event):void 
				{
					var instance1:ExampleClass = instanceRecipes.getRecipeFor(ExampleClass).instance;
					assertThat(instance1, instanceOf(ExampleClass));
					
					var classRecipe1:ClassRecipe = classRecipes.getRecipeFor(ExampleClass);
					assertThat(instance1, instanceOf(classRecipe1.proxyClass));
					
					var instance2:ExampleClass = instanceRecipes.getRecipeFor(ExampleClass, [for_sample_only]).instance;
					assertThat(instance2, instanceOf(ExampleClass));
					
					var classRecipe2:ClassRecipe = classRecipes.getRecipeFor(ExampleClass, [for_sample_only]);
					assertThat(instance2, instanceOf(classRecipe2.proxyClass));
					
					async.dispatchEvent(new Event(Event.COMPLETE));
				}
			});
		}
	}
}