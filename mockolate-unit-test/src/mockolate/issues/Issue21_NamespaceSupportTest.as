package mockolate.issues
{
	import flash.utils.describeType;
	import flash.utils.flash_proxy;
	
	import mockolate.expect;
	import mockolate.mock;
	import mockolate.received;
	import mockolate.record;
	import mockolate.replay;
	import mockolate.runner.MockolateRule;
	
	import mx.collections.ListCollectionView;
	
	import org.flemit.reflection.Type;
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	
	use namespace flash_proxy;
	use namespace test_namespace;

	public class Issue21_NamespaceSupportTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();
		
		[Mock(namespaces="flash.utils.flash_proxy,mockolate.issues.test_namespace")]
		public var instance:Issue21_NamespaceSupport_ClassWithNamespace;
				
		[Test]
		public function nsMethod_shouldInterceptProxyGetProperty():void 
		{
			mock(instance).nsMethod(flash_proxy, "getProperty").args("2").returns(5).once();
			
			assertThat(instance[2], equalTo(5));
		}
		
		[Test]
		public function nsMethod_shouldInterceptProxySetProperty():void
		{
			mock(instance).nsMethod(flash_proxy, "setProperty").args("2", 5).once();
			
			instance[2]	= 5;
		}
			
		[Test]
		public function nsMethod_shouldInterceptProxyCallProperty():void
		{
			mock(instance).nsMethod(flash_proxy, "callProperty")
				.args(hasProperties({ localName: "undefinedMethod" }), 1, 2, 3).once();
			
			instance.undefinedMethod(1, 2, 3);
		}
		
		[Test]
		public function nsMethod_shouldInterceptProxyDeleteProperty():void 
		{
			mock(instance).nsMethod(flash_proxy, "deleteProperty")
				.args(hasProperties({ localName: "undefinedProperty" })).once();
			
			delete instance.undefinedProperty;
		}
		
		[Test]
		public function nsMethod_shouldInterceptProxyGetDescendants():void 
		{
			mock(instance).nsMethod(flash_proxy, "getDescendants")
				.args(hasProperties({ localName: "undefinedDescendants" })).returns([ 1, 2, 3 ]).once();
			
			assertThat(instance..undefinedDescendants, array(1, 2, 3));
		}
		
		[Test]
		public function nsMethod_shouldInterceptProxyHasProperty():void 
		{
			mock(instance).nsMethod(flash_proxy, "hasProperty").args("definedProperty").returns(true).twice();
			mock(instance).nsMethod(flash_proxy, "hasProperty").args("undefinedProperty").returns(false).twice();
			
			assertThat("in definedProperty", "definedProperty" in instance, isTrue());
			assertThat("in undefinedProperty", "undefinedProperty" in instance, isFalse());
			assertThat("hasOwnProperty definedProperty", instance.hasOwnProperty("definedProperty"), isTrue());
			assertThat("hasOwnProperty undefinedProperty", instance.hasOwnProperty("undefinedProperty"), isFalse());
		}
		
		[Ignore]
		[Test]
		public function nsMethod_shouldInterceptProxyIsAttribute():void 
		{
			mock(instance).nsMethod(flash_proxy, "isAttribute")
				.args(hasProperties({ localName: "someAttribute" })).returns(true).once();
			
			// anyone know how to test this?
		}
		
		[Test]
		public function nsMethod_shouldInterceptProxyForIn():void 
		{
			var fields:Array = ["first", "second", "third"];
			
			mock(instance).nsMethod(flash_proxy, "nextName").args(int).callsWithArguments(function(index:int):String {
				return fields[index - 1];
			});
			
			mock(instance).nsMethod(flash_proxy, "nextNameIndex").args(int).callsWithArguments(function(index:int):int {
				return (index < 3) ? index + 1 : 0;
			});
			
			var names:Array = [];
			for (var name:String in instance)
			{
				names[names.length] = name;
			}
			assertThat(names, array("first", "second", "third"));
		}
		
		[Test]
		public function nsMethod_shouldInterceptProxyForEachIn():void 
		{
			var values:Array = [123, 456, 789];
			
			mock(instance).nsMethod(flash_proxy, "nextNameIndex").args(int).callsWithArguments(function(index:int):int {
				return (index < 3) ? index + 1 : 0;
			});
			
			mock(instance).nsMethod(flash_proxy, "nextValue").args(int).callsWithArguments(function(index:int):int {
				return values[index - 1];
			});
			
			var eachValues:Array = [];
			for each (var name:String in instance)
			{
				eachValues[eachValues.length] = name;
			}
			assertThat(eachValues, array(123, 456, 789));
		}
		
		[Test]
		public function nsMethod_shouldInterceptNamespacedMethod():void 
		{
			mock(instance).nsMethod(test_namespace, "methodInNamespace").anyArgs().returns(true).once();;
			
			assertThat(instance.methodInNamespace(), isTrue());
		}
		
		[Test]
		public function nsMethod_shouldInterceptNamespacedGetter():void
		{
			mock(instance).nsGetter(test_namespace, "testGetter").returns(true).once();;
			
			assertThat(instance.testGetter, isTrue());
		}
		
		[Test]
		public function nsMethod_shouldInterceptNamespacedSetter():void 
		{
			mock(instance).nsSetter(test_namespace, "testSetter").arg(true).once();;
			
			instance.testSetter = true;
		}
		
		[Test]
		public function nsMethod_shouldUseExpectationForMatchingNamespace():void 
		{
			// in this case we have added a getProperty method to the ClassWithNamespace that would 
			// shadow the flash_proxy getProperty if we were only checking the method names. 
			mock(instance).nsMethod(test_namespace, "getProperty").args("test").returns({ name: "test" });
			mock(instance).nsMethod(flash_proxy, "getProperty").args("proxy").returns({ name: "proxy" });
			
			assertThat(instance.test_namespace::getProperty("test"), hasProperties({ name: "test" }));
			assertThat(instance.flash_proxy::getProperty("proxy"), hasProperties({ name: "proxy" }));
		}
		
		[Test]
		public function invokingNamespacedMethodWithoutExpectation_shouldCallSuperMethod():void
		{ 
			assertThat(instance.test_namespace::getDefaultValue(), equalTo(42));
		}
		
		[Test]
		public function invokingNamespacedGetterWithoutExpectation_shouldCallSuperGetter():void
		{ 
			assertThat(instance.test_namespace::defaultValue, equalTo(42));
		}
	}
}