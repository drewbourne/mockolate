package mockolate.ingredients
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	
	import mockolate.sample.DarkChocolate;
	import mockolate.sample.Flavour;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
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
		public function remove_should_remove_matching_classRecipes():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).build());
			
			classRecipes.remove(aClassRecipe().withClassToPrepare(Flavour).build());
			
			assertThat(classRecipes.numRecipes, equalTo(0));
			assertThat(classRecipes.hasRecipeFor(Flavour), equalTo(false));
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
			
			assertThat("returns classRecipe", classRecipes.getRecipeFor(Flavour), equalTo(classRecipe));
			assertThat("returns otherRecipe", classRecipes.getRecipeFor(Flavour, [flash_proxy]), equalTo(otherRecipe));
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
			
			assertThat("classRecipes.hasRecipeFor(Flavour) should be true", 
						classRecipes.hasRecipeFor(Flavour), isTrue());
			
			assertThat("classRecipes.hasRecipeFor(Flavour, [ for_sample_only ]) should be false", 
						classRecipes.hasRecipeFor(Flavour, [ for_sample_only ]), isFalse());
		}
		
		[Test]
		public function hasRecipeFor_withClassToPrepareAndNamespacesToProxy_shouldBeTrue():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Flavour).withNamespacesToProxy([ for_sample_only ]).build());
			
			assertThat("classRecipes.hasRecipeFor(Flavour) should be false", 
						classRecipes.hasRecipeFor(Flavour), isFalse());
			
			assertThat("classRecipes.hasRecipeFor(Flavour, [ for_sample_only ]) should be true",
						classRecipes.hasRecipeFor(Flavour, [ for_sample_only ]), isTrue());
		}
		
		[Test]
		public function without_should_return_new_ClassRecipes_without_the_matching_classRecipe_instances():void 
		{
			classRecipes.add(aClassRecipe().withClassToPrepare(Sprite).build());
			classRecipes.add(aClassRecipe().withClassToPrepare(Shape).build());
			classRecipes.add(aClassRecipe().withClassToPrepare(Event).build());
			classRecipes.add(aClassRecipe().withClassToPrepare(EventDispatcher).build());
			
			var otherClassRecipes:ClassRecipes = new ClassRecipes();
			otherClassRecipes.add(aClassRecipe().withClassToPrepare(Sprite).build());
			otherClassRecipes.add(aClassRecipe().withClassToPrepare(EventDispatcher).build());
			otherClassRecipes.add(aClassRecipe().withClassToPrepare(IEventDispatcher).build());
			
			var result:ClassRecipes = classRecipes.without(otherClassRecipes);
			
			assertThat(result.numRecipes, equalTo(2));
			assertThat(result.toArray(), array(hasProperties({ classToPrepare: Shape }), hasProperties({ classToPrepare: Event })));
		}
	}
}