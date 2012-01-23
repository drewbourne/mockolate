package mockolate.ingredients
{
	import flash.display.Sprite;
	import flash.utils.flash_proxy;
	
	import mockolate.sample.DarkChocolate;
	import mockolate.sample.Flavour;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	
	public class ClassRecipeTest
	{
		public var classRecipe:ClassRecipe;
		
		[Test]
		public function classToPrepare_shouldGetAndSet():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.classToPrepare = Flavour;
			
			assertThat(classRecipe.classToPrepare, equalTo(Flavour));
		}
		
		[Test]
		public function namespacesToProxy_shouldGetAndSet():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.namespacesToProxy = [ for_sample_only ];
			
			assertThat(classRecipe.namespacesToProxy, array(for_sample_only));
		}
		
		[Test]
		public function proxyClass_shouldGetAndSet():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.proxyClass = Flavour;
			
			assertThat(classRecipe.proxyClass, equalTo(Flavour));
		}
		
		[Test]
		public function matches_with_matching_class_only():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.classToPrepare = Flavour;
			
			assertThat("classRecipe.matches(Flavour, null)", 
						classRecipe.matches(Flavour, null), isTrue());
			
			assertThat("classRecipe.matches(Flavour, [])", 
						classRecipe.matches(Flavour, []), isTrue());
		}
		
		[Test]
		public function matches_with_matching_class_only_empty_namespaces():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.classToPrepare = Flavour;
			classRecipe.namespacesToProxy = [];
			
			assertThat("classRecipe.matches(Flavour, null)", 
				classRecipe.matches(Flavour, null), isTrue());
			
			assertThat("classRecipe.matches(Flavour, [])", 
				classRecipe.matches(Flavour, []), isTrue());
		}
		
		[Test]
		public function matches_with_matching_class_and_namespaces():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.classToPrepare = Flavour;
			classRecipe.namespacesToProxy = [ for_sample_only ];
			
			assertThat("classRecipe.matches(Flavour, [ for_sample_only ])", 
						classRecipe.matches(Flavour, [ for_sample_only ]), isTrue());
		}
		
		[Test]
		public function matches_with_mismatched_class_only():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.classToPrepare = Flavour;
			
			assertThat("classRecipe.matches(DarkChocolate, null)", 
						classRecipe.matches(DarkChocolate, null), isFalse());
			
			assertThat("classRecipe.matches(DarkChocolate, [])", 
						classRecipe.matches(DarkChocolate, []), isFalse());
			
			assertThat("classRecipe.matches(DarkChocolate, [ for_sample_only ])", 
						classRecipe.matches(DarkChocolate, [ for_sample_only ]), isFalse());
			
			assertThat("classRecipe.matches(Flavour, [ for_sample_only ])", 
						classRecipe.matches(Flavour, [ for_sample_only ]), isFalse());
		}
		
		[Test]
		public function matches_with_mismatched_class_and_namespaces():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.classToPrepare = Flavour;
			classRecipe.namespacesToProxy = [ for_sample_only ];
			
			assertThat("classRecipe.matches(Flavour, null)", 
				classRecipe.matches(Flavour, null), isFalse());
			
			assertThat("classRecipe.matches(Flavour, [])", 
				classRecipe.matches(Flavour, []), isFalse());
			
			assertThat("classRecipe.matches(DarkChocolate, [ for_sample_only ])", 
						classRecipe.matches(DarkChocolate, [ for_sample_only ]), isFalse());
			
			assertThat("classRecipe.matches(DarkChocolate, [ for_sample_only, flash_proxy ])", 
				classRecipe.matches(DarkChocolate, [ for_sample_only, flash_proxy ]), isFalse());
		}
	}
}