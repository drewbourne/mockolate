package mockolate.ingredients
{
	public class InstanceRecipes
	{
		private var _instanceRecipes:Array;
		
		public function InstanceRecipes()
		{
			_instanceRecipes = [];
		}
		
		public function get numRecipes():uint 
		{
			return _instanceRecipes.length;
		}
		
		public function add(instanceRecipe:InstanceRecipe):void
		{
			_instanceRecipes.push(instanceRecipe);
		}
		
		public function getRecipeFor(classReference:Class, namespaces:Array = null):InstanceRecipe
		{
			for each (var instanceRecipe:InstanceRecipe in _instanceRecipes)
			{
				if (instanceRecipe.classRecipe.matches(classReference, namespaces))
				{
					return instanceRecipe;
				}
			}
			
			return null;
		}
		
		public function toArray():Array
		{
			return _instanceRecipes.slice();
		}
	}
}