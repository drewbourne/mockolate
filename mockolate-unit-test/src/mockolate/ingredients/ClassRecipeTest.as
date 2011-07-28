package mockolate.ingredients
{
	import flash.utils.flash_proxy;
	
	import mockolate.sample.Flavour;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	
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
			classRecipe.namespacesToProxy = Vector.<Namespace>([ for_sample_only ]);
			
			assertThat(classRecipe.namespacesToProxy, array(for_sample_only));
		}
		
		[Test]
		public function proxyClass_shouldGetAndSet():void 
		{
			classRecipe = new ClassRecipe();
			classRecipe.proxyClass = Flavour;
			
			assertThat(classRecipe.proxyClass, equalTo(Flavour));
		}
	}
}