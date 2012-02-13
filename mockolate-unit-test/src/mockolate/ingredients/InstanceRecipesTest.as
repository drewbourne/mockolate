package mockolate.ingredients
{
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;

	public class InstanceRecipesTest
	{
		public var instanceRecipes:InstanceRecipes;
		public var instanceRecipe:InstanceRecipe;
		public var classRecipe:ClassRecipe;
		
		[Before]
		public function setup():void 
		{
			instanceRecipes = new InstanceRecipes();
			classRecipe = aClassRecipe().withClassToPrepare(Flavour).build()
		}
		
		[Test]
		public function add_should_increase_numRecipes_by_one():void 
		{
			instanceRecipes.add(anInstanceRecipe().withClassRecipe(classRecipe).build());
			
			assertThat("instanceRecipes.numRecipes should be 1", 
						instanceRecipes.numRecipes, equalTo(1));
			
			instanceRecipes.add(anInstanceRecipe().withClassRecipe(classRecipe).build());
			
			assertThat("instanceRecipes.numRecipes should be 2", 
						instanceRecipes.numRecipes, equalTo(2));
		}
		
		[Test]
		public function toArray_should_return_added_instanceRecipes():void
		{
			var instanceRecipe1:InstanceRecipe = anInstanceRecipe().withClassRecipe(classRecipe).build();
			var instanceRecipe2:InstanceRecipe = anInstanceRecipe().withClassRecipe(classRecipe).build();
			
			instanceRecipes.add(instanceRecipe1);
			instanceRecipes.add(instanceRecipe2);
			
			assertThat(instanceRecipes.toArray(), array(instanceRecipe1, instanceRecipe2));
		}
	}
}