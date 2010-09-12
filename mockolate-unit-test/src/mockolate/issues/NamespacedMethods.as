package mockolate.issues
{
	import flash.utils.describeType;
	import flash.utils.flash_proxy;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import mx.collections.ListCollectionView;
	
	import org.flemit.reflection.Type;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	
	use namespace flash_proxy;
	use namespace test_namespace;

	public class NamespacedMethods
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock]
		public var instance:ClassWithNamespaces;
		
		[Test]
		public function doesTypeHaveNamespacedMethods():void 
		{
			var desc:XML = describeType(ClassWithNamespaces);
			trace(desc);
			
			var type:Type = Type.getType(ClassWithNamespaces);
		}
		
		[Test]
		public function mockFlashProxyNamespacedMethod():void 
		{
			mock(instance).nsMethod(flash_proxy, "getProperty").args("2").returns(5);
			
			assertThat(instance[2], equalTo(5));
		}
		
		[Test]
		public function mockTestNamespacedMethod():void 
		{
			mock(instance).nsMethod(test_namespace, "methodInNamespace").anyArgs().returns(true);
			
			assertThat(instance.methodInNamespace(), isTrue());
		}
		
		[Test]
		public function doesInstanceHaveProxiedNamespacedMethod():void 
		{
			instance[2];
			
			instance.methodInNamespace();
			
			instance.publicMethod();
		}	
	}
}