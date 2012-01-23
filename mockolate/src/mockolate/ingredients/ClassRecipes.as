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
		
		public function remove(classRecipe:ClassRecipe):void 
		{
			var index:int = _classRecipes.indexOf(getRecipeFor(classRecipe.classToPrepare, classRecipe.namespacesToProxy));
			if (index != -1)
			{
				_classRecipes.splice(index, 1);
			}
		}
		
		public function hasRecipe(classRecipe:ClassRecipe):Boolean 
		{
			return !!getRecipeFor(classRecipe.classToPrepare, classRecipe.namespacesToProxy);
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
		
		public function without(otherClassRecipes:ClassRecipes):ClassRecipes 
		{
			var classRecipes:ClassRecipes = new ClassRecipes();
			
			for each (var classRecipe:ClassRecipe in toArray()) 
			{
				if (!otherClassRecipes.hasRecipe(classRecipe))
				{
					classRecipes.add(classRecipe);
				}
			}
			
			return classRecipes;
		}
		
		public function toArray():Object
		{
			return _classRecipes.slice();
		}
	}
}