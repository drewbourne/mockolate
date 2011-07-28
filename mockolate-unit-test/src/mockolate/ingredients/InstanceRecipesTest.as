package mockolate.ingredients
{
	public class InstanceRecipesTest
	{
		public var instanceRecipes:InstanceRecipes;
		public var instanceRecipe:InstanceRecipe;
		public var classRecipe:ClassRecipe;
		
		[Before]
		public function setup():void 
		{
			instanceRecipes = new InstanceRecipes();
		}
	}
}