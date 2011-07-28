package mockolate.ingredients
{
	import flash.utils.flash_proxy;
	
	import mockolate.sample.DarkChocolate;
	import mockolate.sample.Flavour;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.nullValue;

	public class ClassRecipesTest
	{
		public var classRecipes:ClassRecipes;
		public var classRecipe:ClassRecipe;
		
		[Before]
		public function setup():void 
		{
			classRecipes = new ClassRecipes();
		}
		
		[Test]
		public function add_shouldHaveClassRecipeForSameClass():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).build());
			
			assertThat(classRecipes.hasRecipeFor(Flavour), isTrue());
		}
		
		[Test]
		public function add_shouldNotAddMoreThanOnce():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).build());
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).build());
			
			assertThat(classRecipes.hasRecipeFor(Flavour), isTrue());
			assertThat(classRecipes.numRecipes, equalTo(1));
		}
		
		[Test]
		public function getRecipeFor_withClass_shouldReturnMatchingClassRecipe():void 
		{
			var classRecipe:ClassRecipe = aClassRecipe().withClassToPrepare(Flavour).build();
			var otherRecipe:ClassRecipe = aClassRecipe().withClassToPrepare(DarkChocolate).build();
			
			classRecipes.add(classRecipe);
			classRecipes.add(otherRecipe);
			
			assertThat(classRecipes.getRecipeFor(Flavour), equalTo(classRecipe));
			assertThat(classRecipes.getRecipeFor(DarkChocolate), equalTo(otherRecipe));
		}
		
		[Test]
		public function getRecipeFor_withClassAndNamespace_shouldReturnMatchingClassRecipe():void 
		{
			var classRecipe:ClassRecipe = aClassRecipe().withClassToPrepare(Flavour).build();
			var otherRecipe:ClassRecipe = aClassRecipe().withClassToPrepare(Flavour).withNamespacesToProxy([flash_proxy]).build();
			
			classRecipes.add(classRecipe);
			classRecipes.add(otherRecipe);
			
			assertThat(classRecipes.getRecipeFor(Flavour), equalTo(classRecipe));
			assertThat(classRecipes.getRecipeFor(Flavour, [flash_proxy]), equalTo(otherRecipe));
		}
		
		[Test]
		public function getRecipeFor_withClassAndNamespace_withNoMatchingClassRecipe_shouldReturnNull():void 
		{
			assertThat(classRecipes.getRecipeFor(Flavour), nullValue());
		}
		
		[Test]
		public function hasRecipeFor_withClassToPrepare_shouldBeTrue():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).build());
			
			assertThat(classRecipes.hasRecipeFor(Flavour), isTrue());
			assertThat(classRecipes.hasRecipeFor(Flavour, [ for_sample_only ]), isFalse());
		}
		
		[Test]
		public function hasRecipeFor_withClassToPrepareAndNamespacesToProxy_shouldBeTrue():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).withNamespacesToProxy([ for_sample_only ]).build());
			
			assertThat(classRecipes.hasRecipeFor(Flavour), isFalse());
			assertThat(classRecipes.hasRecipeFor(Flavour, [ for_sample_only ]), isTrue());
		}
	}
}