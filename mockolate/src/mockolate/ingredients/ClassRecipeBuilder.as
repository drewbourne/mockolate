package mockolate.ingredients
{
	import mockolate.errors.MockolateError;

	public class ClassRecipeBuilder
	{
		private var _classToPrepare:Class;
		
		public function withClassToPrepare(classToPrepare:Class):ClassRecipeBuilder 
		{
			_classToPrepare = classToPrepare;
			return this;
		}
		
		private var _namespacesToProxy:Array; // Vector.<Namespace>;
		
		public function withNamespacesToProxy(namespacesToProxy:Array):ClassRecipeBuilder 
		{
			_namespacesToProxy = namespacesToProxy; //Vector.<Namespace>(namespacesToProxy);
			return this;
		}
		
		public function build():ClassRecipe 
		{
			validate();
			
			var classRecipe:ClassRecipe = new ClassRecipe();
			classRecipe.classToPrepare = _classToPrepare;
			classRecipe.namespacesToProxy = _namespacesToProxy;
			return classRecipe;;
		}
		
		private function validate():void 
		{
			if (!_classToPrepare)
			{
				throw new MockolateError("ClassRecipeBuilder requires a classToPrepare", null, null);
			}
		}
	}
}