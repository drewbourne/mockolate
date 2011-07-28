package mockolate.runner
{
	import asx.array.compact;
	import asx.array.contains;
	import asx.array.filter;
	import asx.array.map;
	import asx.string.substitute;
	import asx.string.trim;
	
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;
	
	import mockolate.ingredients.MockType;

	[ExcludeClass]
	
	/**
	 * Factory for MockMetadata using FlexUnit reflection.
	 */
	public class MockMetadataFactory
	{
		private const MOCK_METADATA:String = "Mock";
		private const INJECT_ATTRIBUTE:String = "inject";
		private const MOCK_TYPE_ATTRIBUTE:String = "type";
		private const NAMESPACES_ATTRIBUTE:String = "namespaces";
		private const TRUE:String = "true";
		private const FALSE:String = "false";
		
		public function createForKlass(klass:Klass):Array 
		{
			var mockFields:Array = filter(klass.fields, isMockField);			
			var mockMetadatas:Array = map(mockFields, createForField);			
			return mockMetadatas;
		}
		
		public function createForField(field:Field):MockMetadata 
		{
			var metadata:MetaDataAnnotation = field.getMetaData(MOCK_METADATA);
			
			var result:MockMetadata = new MockMetadata();
			result.injectable = parseInjectable(field, metadata);
			result.mockType = parseMockType(field, metadata); 
			result.name = field.name;
			result.namespacesToProxy = parseNamespacesToProxy(field, metadata);
			result.type = field.type;
			return result;	
		}
		
		private function isMockField(field:Field):Boolean 
		{
			return field.hasMetaData(MOCK_METADATA);
		}
		
		private function parseInjectable(field:Field, metadata:MetaDataAnnotation):Boolean
		{
			var attribute:MetaDataArgument = metadata.getArgument(INJECT_ATTRIBUTE);
			var injectableValue:String = attribute ? (attribute.value).toLowerCase() : TRUE;
			var injectable:Boolean;
			
			if (!contains([ TRUE, FALSE ], injectableValue))
			{
				throw new Error(substitute(
					"Property '{}' must declare the attribute 'inject' as either "
					+ "'true' or 'false'; '{}' is NOT valid.",
					field.name, injectable));
			}
			
			injectable = injectableValue == TRUE;
			
			return injectable;
		}
		
		private function parseMockType(field:Field, metadata:MetaDataAnnotation):MockType
		{
			var attribute:MetaDataArgument = metadata.getArgument(MOCK_TYPE_ATTRIBUTE);
			var mockTypeValue:String = attribute ? attribute.value : null; 
			var mockType:MockType = MockType.NICE;
			
			try 
			{
				mockType = attribute ? MockType.enumFor(attribute.value) : MockType.NICE;
			}
			catch (error:Error)
			{
				var message:String = substitute("Property '{}' must declare a 'type' of 'nice', 'strict' or 'partial', '{}' is NOT a valid type.", field.name, mockTypeValue);
				throw new Error(message);
			}
			
			return mockType;
		}
		
		private function parseNamespacesToProxy(field:Field, metadata:MetaDataAnnotation):Array 
		{
			var attribute:MetaDataArgument = metadata.getArgument(NAMESPACES_ATTRIBUTE);
			var attributeValue:String = (attribute ? attribute.value : "");
			var fqns:Array = map(attributeValue.split(","), trim);
			var namespacesToProxy:Array = compact(map(fqns, function(fqn:String):Namespace {
				var ns:Namespace;
				if (fqn) {
					ns = ApplicationDomain.currentDomain.getDefinition(fqn) as Namespace;
				}
				return ns;
			}));
			return namespacesToProxy;
		}
	}
}