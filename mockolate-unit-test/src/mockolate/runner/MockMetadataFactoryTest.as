package mockolate.runner
{
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	
	import mockolate.ingredients.MockType;
	import mockolate.runner.statements.TestExample;
	import mockolate.sample.ExampleClass;
	import mockolate.sample.for_sample_only;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;

	public class MockMetadataFactoryTest
	{
		public var factory:MockMetadataFactory;
		public var klass:Klass;
		
		[Before]
		public function setup():void 
		{
			factory = new MockMetadataFactory();
			klass = new Klass(TestExample);
		}
				
		[Test]
		public function createForField_example_shouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("example");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("injectable is true", 
				result.injectable, isTrue());
			
			assertThat("mockType is NICE", 
				result.mockType, equalTo(MockType.NICE));
			
			assertThat("name is 'example'", 
				result.name, equalTo("example"));
			
			assertThat("namespacesToProxy is empty", 
				result.namespacesToProxy, emptyArray());
			
			assertThat("type is Example", 
				result.type, equalTo(ExampleClass));
		}
		
		[Test]
		public function createForField_exampleDontInject_shouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("exampleDontInject");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("injectable is false", 
				result.injectable, isFalse());
		}
		
		[Test]
		public function createForField_exampleNicely_shouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("exampleNicely");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("mockType is NICE", 
				result.mockType, equalTo(MockType.NICE));
		}
		
		[Test]
		public function createForField_exampleStrictly_shouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("exampleStrictly");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("mockType is STRICT", 
				result.mockType, equalTo(MockType.STRICT));
		}
		
		[Test]
		public function createForField_examplePartially_shouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("examplePartially");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("mockType is PARTIAL", 
				result.mockType, equalTo(MockType.PARTIAL));
		}
		
		[Test]
		public function createForField_exampleNamespacesshouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("exampleNamespaces");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("namespacesToProxy is array of Namespace", 
				result.namespacesToProxy, array(for_sample_only));
		}
		
		[Test]
		public function createForField_exampleConstructor_shouldExtractValuesFromFieldMetadata():void 
		{
			const field:Field = klass.getField("exampleConstructor");
			
			var  result:MockMetadata = factory.createForField(field);
			
			assertThat("constructorArgs is array of values", 
				result.namespacesToProxy, array(for_sample_only));
		}
		
		[Test]
		public function createForKlass_shouldCreateForAllIdentifiableFields():void 
		{
			var result:Array = factory.createForKlass(klass);
			
			assertThat("expecting MockMetadata for 7 fields", 
				result.length, equalTo(7));
			
			assertThat("expecting MockMetadata for each public field with [Mock]", 
				result, everyItem(instanceOf(MockMetadata)));
		}
	}
}