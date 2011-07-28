package mockolate.ingredients
{
	import mockolate.errors.MockolateError;

	public class InstanceRecipeBuilder
	{
		private var _classRecipe:ClassRecipe;
		
		public function withClassRecipe(classRecipeOrBuilder:*):InstanceRecipeBuilder 
		{
			if (classRecipeOrBuilder is ClassRecipeBuilder)
			{
				_classRecipe = (classRecipeOrBuilder as ClassRecipeBuilder).build();	
			}
			else if (classRecipeOrBuilder is ClassRecipe)
			{
				_classRecipe = (classRecipeOrBuilder as ClassRecipe);
			}
			else
			{
				throw new MockolateError("", null, null);
			}
			
			return this;
		}
		
		private var _constructorArgs:Array;
		
		public function withConstructorArgs(constructorArgs:Array):InstanceRecipeBuilder
		{
			_constructorArgs = constructorArgs;
			return this;
		}
		
		private var _inject:Boolean;
		
		public function withInject(inject:Boolean):InstanceRecipeBuilder
		{
			_inject = inject;
			return this;
		}
		
		private var _mockType:MockType;
		
		public function withMockType(mockType:MockType):InstanceRecipeBuilder
		{
			_mockType = mockType;
			return this;
		}
		
		private var _name:String;
		
		public function withName(name:String):InstanceRecipeBuilder
		{
			_name = name;
			return this;
		}
		
		public function build():InstanceRecipe
		{
			validate();
			
			var instanceRecipe:InstanceRecipe = new InstanceRecipe();
			instanceRecipe.classRecipe = _classRecipe;
			instanceRecipe.constructorArgs = _constructorArgs;
			instanceRecipe.inject = _inject;
			instanceRecipe.mockType = _mockType;
			instanceRecipe.name = _name;
			return instanceRecipe;
		}
		
		private function validate():void
		{
			if (!_classRecipe)
			{
				throw new MockolateError("InstanceRecipeBuilder requires a classRecipe", null, null);
			}
		}
	}
}