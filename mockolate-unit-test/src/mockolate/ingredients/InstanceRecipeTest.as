package mockolate.ingredients
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class InstanceRecipeTest
	{
		public var instanceRecipe:InstanceRecipe;
		
		[Before]
		public function create():void 
		{
			instanceRecipe = new InstanceRecipe();
		}
		
		[Test]
		public function classRecipe_shouldGetAndSet():void 
		{
			var classRecipe:ClassRecipe = new ClassRecipe();
			
			instanceRecipe.classRecipe = classRecipe;
			
			assertThat(instanceRecipe.classRecipe, equalTo(classRecipe));
		}
		
		[Test]
		public function name_shouldGetAndSet():void 
		{
			var name:String = "test";
			
			instanceRecipe.name = name;
			
			assertThat(instanceRecipe.name, equalTo(name));
		}
		
		[Test]
		public function constructorArgs_shouldGetAndSet():void 
		{
			var constructorArgs:Array = [1,2,3];
			
			instanceRecipe.constructorArgs = constructorArgs;
			
			assertThat(instanceRecipe.constructorArgs, equalTo(constructorArgs));
		}
		
		[Test]
		public function mockType_shouldGetAndSet():void 
		{
			var mockType:MockType = MockType.STRICT;
			
			instanceRecipe.mockType = mockType;
			
			assertThat(instanceRecipe.mockType, equalTo(mockType));
		}
	}
}