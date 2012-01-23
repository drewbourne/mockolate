package mockolate.ingredients
{
	import mockolate.errors.MockolateError;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.instanceOf;

	public class InstanceRecipeBuilderTest
	{
		[Test]
		public function withClassRecipe_withClassRecipe_shouldSetClassRecipe():void 
		{
			var classRecipe:ClassRecipe = aClassRecipe().withClassToPrepare(Flavour).build();
			
			var instanceRecipe:InstanceRecipe
				= anInstanceRecipe()
				.withClassRecipe(classRecipe)
				.build();
				
			assertThat(instanceRecipe, hasProperties({ classRecipe: classRecipe }));
		}
		
		[Test]
		public function withClassRecipe_withClassRecipeBuilder_shouldSetClassRecipe():void 
		{
			var classRecipeBuilder:ClassRecipeBuilder = aClassRecipe().withClassToPrepare(Flavour);
			
			var instanceRecipe:InstanceRecipe
				= anInstanceRecipe()
				.withClassRecipe(classRecipeBuilder)
				.build();
			
			assertThat(instanceRecipe, hasProperties({ classRecipe: instanceOf(ClassRecipe) }));
		}
		
		[Test]
		public function withClassRecipe_withOtherClass_shouldComplain():void 
		{
			assertThat(function():void {
				anInstanceRecipe().withClassRecipe(Flavour);
			}, throws(MockolateError));
		}

		[Test]
		public function withConstructorArgs_shouldSetConstructorArgs():void 
		{
			var constructorArgs:Array = [1,2,3];
			
			var instanceRecipe:InstanceRecipe
				= anInstanceRecipe()
				.withConstructorArgs(constructorArgs)
				.withClassRecipe(aClassRecipe().withClassToPrepare(Flavour))
				.build();
			
			assertThat(instanceRecipe, hasProperties({ constructorArgs: constructorArgs }));
		}
		
		[Test]
		public function withInject_shouldSetInject():void 
		{
			var instanceRecipe:InstanceRecipe
				= anInstanceRecipe()
				.withInject(true)
				.withClassRecipe(aClassRecipe().withClassToPrepare(Flavour))
				.build();
			
			assertThat(instanceRecipe, hasProperties({ inject: true }));
		}
				
		[Test]
		public function withMockType_shouldSetMockType():void 
		{
			var mockType:MockType = MockType.STRICT;
			
			var instanceRecipe:InstanceRecipe
				= anInstanceRecipe()
				.withMockType(mockType)
				.withClassRecipe(aClassRecipe().withClassToPrepare(Flavour))
				.build();
			
			assertThat(instanceRecipe, hasProperties({ mockType: mockType }));
		}
		
		[Test]
		public function withName_shouldSetName():void
		{
			var name:String = "test";
			
			var instanceRecipe:InstanceRecipe
				= anInstanceRecipe()
				.withName(name)
				.withClassRecipe(aClassRecipe().withClassToPrepare(Flavour))
				.build();
			
			assertThat(instanceRecipe, hasProperties({ name: name }));
		}
		
		[Test]
		public function build_withoutClassRecipe_shouldComplain():void
		{
			assertThat(function():void {
				anInstanceRecipe().build();
			}, throws(MockolateError));
		}
	}
}