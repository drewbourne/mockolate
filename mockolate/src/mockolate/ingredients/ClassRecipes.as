package mockolate.ingredients
{
	public class ClassRecipes
	{
		private var _classRecipes:Array;
		
		public function ClassRecipes()
		{
			_classRecipes = [];
		}
		
		public function get numRecipes():uint
		{
			return _classRecipes.length;
		}

		public function add(classRecipe:ClassRecipe):void
		{
			if (!hasRecipeFor(classRecipe.classToPrepare, classRecipe.namespacesToProxy))
			{
				_classRecipes.push(classRecipe);
			}
		}
		
		public function hasRecipeFor(classReference:Class, namespaces:Array = null):Boolean
		{
			return !!getRecipeFor(classReference, namespaces);
		}
		
		public function getRecipeFor(classReference:Class, namespaces:Array = null):ClassRecipe
		{
			for each (var classRecipe:ClassRecipe in _classRecipes)
			{
				if (classRecipe.matches(classReference, namespaces))
				{
					return classRecipe;
				}
			}
			
			return null;
		}
		
		public function toArray():Object
		{
			return _classRecipes.slice();
		}
	}
}