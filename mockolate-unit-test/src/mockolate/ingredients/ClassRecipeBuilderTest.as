package mockolate.ingredients
{
	import mockolate.errors.MockolateError;
	import mockolate.sample.DarkChocolate;
	import mockolate.sample.Flavour;
	import mockolate.sample.for_sample_only;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.hasProperties;

	public class ClassRecipeBuilderTest
	{
		[Test]
		public function withClass_shouldSetClassToPrepare():void 
		{
			var classRecipe:ClassRecipe 
				= aClassRecipe()
				.withClassToPrepare(Flavour)
				.build();
			
			assertThat(classRecipe, hasProperties({ classToPrepare: Flavour }));
		}
		
		[Test]
		public function withNamespaces_shouldSetNamespacesToProxy():void 
		{
			var classRecipe:ClassRecipe 
				= aClassRecipe()
				.withClassToPrepare(Flavour)
				.withNamespacesToProxy([ for_sample_only ])
				.build();
			
			assertThat(classRecipe, hasProperties({ namespacesToProxy: array(for_sample_only) }));
		}
		
		[Test]
		public function build_withoutClass_shouldComplain():void 
		{
			assertThat(function():void {
				aClassRecipe().build();
			}, throws(MockolateError));
		}
	}
}