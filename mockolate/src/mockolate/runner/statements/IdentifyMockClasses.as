package mockolate.runner.statements
{
	import asx.string.formatToString;
	
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	
	import mockolate.ingredients.ClassRecipes;
	import mockolate.ingredients.InstanceRecipes;
	import mockolate.runner.MockMetadata;
	import mockolate.runner.MockMetadataFactory;
	import mockolate.runner.MockolateRunnerConstants;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.runner.MockolateRunnerStatement;
	
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;
	
	/**
	 * Identifies the fields on the TestCase class that should have classes 
	 * prepared and mock instances injected. 
	 * 
	 * @see mockolate.runner.MockolateRule
	 * @see mockolate.runner.MockolateRunner
	 * 
	 * @author drewbourne
	 */
	public class IdentifyMockClasses extends MockolateRunnerStatement implements IAsyncStatement
	{
		/**
		 * Constructor.
		 * 
		 * @param data
		 */
		public function IdentifyMockClasses(data:MockolateRunnerData)
		{
			super(data);
		}
		
		/**
		 * @private
		 */
		public function evaluate(parentToken:AsyncTestToken):void 
		{
			// TODO ApplicationDomain should be injected in constructor
			var testClass:Class = Class(ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(data.test)));
			var klass:Klass = new Klass(testClass);
			var recipeIdentifier:MockolateRecipeIdentifier = new MockolateRecipeIdentifier(data.mockolatier);
			
			data.classRecipes = new ClassRecipes();
			recipeIdentifier.identifyClassRecipes(data.test, klass, data.classRecipes);
			
			data.instanceRecipes = new InstanceRecipes();
			recipeIdentifier.identifyInstanceRecipes(data.test, klass, data.classRecipes, data.instanceRecipes);
			
			parentToken.sendResult();
		}
		
		/**
		 * @private
		 */
		override public function toString():String 
		{
			return formatToString(this, "IdentifyMockClasses");
		}
	}
}

import asx.array.compact;
import asx.array.filter;
import asx.array.map;
import asx.string.substitute;
import asx.string.trim;

import flash.system.ApplicationDomain;

import flex.lang.reflect.Field;
import flex.lang.reflect.Klass;
import flex.lang.reflect.Method;
import flex.lang.reflect.metadata.MetaDataAnnotation;
import flex.lang.reflect.metadata.MetaDataArgument;

import mockolate.ingredients.ClassRecipe;
import mockolate.ingredients.ClassRecipes;
import mockolate.ingredients.InstanceRecipe;
import mockolate.ingredients.InstanceRecipes;
import mockolate.ingredients.MockType;
import mockolate.ingredients.Mockolatier;
import mockolate.ingredients.aClassRecipe;
import mockolate.ingredients.anInstanceRecipe;

internal class MockolateRecipeIdentifier 
{
	private const MOCK_METADATA:String = "Mock";
	private const ARGUMENTS_ATTRIBUTE:String = "args";
	private const NAMESPACES_ATTRIBUTE:String = "namespaces";
	private const INJECT_ATTRIBUTE:String = "inject";
	private const MOCK_TYPE_ATTRIBUTE:String = "type";
	private const TRUE:String = "true";
	private const FALSE:String = "false";
	
	private var _mockolatier:Mockolatier;
	
	public function MockolateRecipeIdentifier(mockolatier:Mockolatier) 
	{
		_mockolatier = mockolatier;
	}
	
	public function identifyClassRecipes(test:*, fromKlass:Klass, intoClassRecipes:ClassRecipes):void 
	{
		var mockFields:Array = filter(fromKlass.fields, isMockField);
		
		for each (var field:Field in mockFields)
		{
			var metadata:MetaDataAnnotation = field.getMetaData(MOCK_METADATA);
			var classToPrepare:Class = field.type;
			var namespacesToProxy:Array = parseNamespacesToProxy(test, fromKlass, field, metadata);
			var classRecipe:ClassRecipe = _mockolatier.preparedClassRecipeFor(classToPrepare, namespacesToProxy);
			
			if (!classRecipe)
			{
				classRecipe = aClassRecipe()
					.withClassToPrepare(classToPrepare)
					.withNamespacesToProxy(namespacesToProxy)
					.build();
			}
			
			intoClassRecipes.add(classRecipe);
		}
	}
	
	public function identifyInstanceRecipes(test:*, fromKlass:Klass, withClassRecipes:ClassRecipes, intoInstanceRecipes:InstanceRecipes):void
	{
		var mockFields:Array = filter(fromKlass.fields, isMockField);
		
		for each (var field:Field in mockFields)
		{
			var metadata:MetaDataAnnotation = field.getMetaData(MOCK_METADATA);
			var namespaces:Array = parseNamespacesToProxy(test, fromKlass, field, metadata);
			var classRecipe:ClassRecipe = withClassRecipes.getRecipeFor(field.type, namespaces);
			
			var instanceRecipe:InstanceRecipe = anInstanceRecipe()
				.withClassRecipe(classRecipe)
				.withConstructorArgsFunction(parseConstructorArgs(test, fromKlass, field, metadata))
				.withMockType(parseMockType(field, metadata))
				.withName(field.name)
				.withInject(parseInject(field, metadata))
				.build();
				
			intoInstanceRecipes.add(instanceRecipe);
		}
	}
	
	private function parseConstructorArgs(test:*, klass:Klass, field:Field, metadata:MetaDataAnnotation):Function
	{
		var attribute:MetaDataArgument = metadata.getArgument(ARGUMENTS_ATTRIBUTE);
		var attributeValue:String = (attribute ? attribute.value : "");
		
		var argumentsField:Field = klass.getField(attributeValue);
		if (argumentsField) 
		{
			return function():Array {
				var result:* = test[argumentsField.name];
				return result as Array;
			}
		}
		
		var argumentsMethod:Method = klass.getMethod(attributeValue);
		if (argumentsMethod)
		{
			return function():Array {
				var result:* = test[argumentsMethod.name]();
				return result as Array;
			}
		}
		
		return null;
	}
	
	private function isMockField(field:Field):Boolean 
	{
		return field.hasMetaData(MOCK_METADATA);
	}
	
	private function parseNamespacesToProxy(test:*, klass:Klass, field:Field, metadata:MetaDataAnnotation):Array 
	{
		var attribute:MetaDataArgument = metadata.getArgument(NAMESPACES_ATTRIBUTE);
		var attributeValue:String = (attribute ? attribute.value : "");
		var namespacesToProxy:Array;
		
		// namespaces are one of:
		// - a public var name that should contain an Array of Namespace
		// - a function name reference that should return an Array of Namespace
		// - a comma-separated list of fully qualified names for the Namespace
		
		var namespaceField:Field = klass.getField(attributeValue);
		if (namespaceField)
		{
			namespacesToProxy = parseNamespacesFromTestField(test, namespaceField);
		}
		
		var namespaceMethod:Method = klass.getMethod(attributeValue);
		if (namespaceMethod) 
		{
			namespacesToProxy = parseNamespacesFromTestMethod(test, namespaceMethod);
		}
		
		if (!namespacesToProxy)
		{
			namespacesToProxy = parseNamespacesFromCSV(attributeValue);
		}
		
		return namespacesToProxy;
	}
	
	private function parseNamespacesFromTestField(test:*, field:Field):Array 
	{
		var result:* = test[field.name]; 
		return result as Array;
	}
	
	private function parseNamespacesFromTestMethod(test:*, method:Method):Array 
	{
		var result:* = test[method.name]();
		return result as Array;
	}
	
	private function parseNamespacesFromCSV(attributeValue:String):Array 
	{
		var fqns:Array = map(attributeValue.split(","), trim);
		var namespacesToProxy:Array = compact(map(fqns, parseNamespaceFromFQN));
		return namespacesToProxy;
	}
	
	private function parseNamespaceFromFQN(fqn:String):Namespace {
		var ns:Namespace;
		if (fqn) 
		{
			ns = ApplicationDomain.currentDomain.getDefinition(fqn) as Namespace;
		}
		return ns;
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
	
	private function parseInject(field:Field, metadata:MetaDataAnnotation):Boolean
	{
		var attribute:MetaDataArgument = metadata.getArgument(INJECT_ATTRIBUTE);
		var injectableValue:String = attribute ? (attribute.value).toLowerCase() : TRUE;
		var injectable:Boolean;
		
		if ([ TRUE, FALSE ].indexOf(injectableValue) == -1)
		{
			throw new Error(substitute(
				"Property '{}' must declare the attribute 'inject' as either "
				+ "'true' or 'false'; '{}' is NOT valid.",
				field.name, injectable));
		}
		
		injectable = injectableValue == TRUE;
		
		return injectable;
	}
}
