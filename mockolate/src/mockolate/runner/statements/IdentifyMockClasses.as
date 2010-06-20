package mockolate.runner.statements
{
	import asx.string.formatToString;
	
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	
	import mockolate.runner.MockMetadata;
	import mockolate.runner.MockolateRunnerConstants;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.runner.MockolateRunnerStatement;
	
	import org.flexunit.internals.runners.InitializationError;
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
			var error:Error = null;
			
			// TODO ApplicationDomain should be injected in constructor
			var testClass:Class = Class(ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(data.test)));
			var klass:Klass = new Klass(testClass);
			
			data.mockMetadatas = [];
			
			for each (var field:Field in klass.fields)
			{
				if (field.hasMetaData(MockolateRunnerConstants.MOCK))
				{
					try
					{
						var metadata:MockMetadata = new MockMetadata(field.name, field.type, field.getMetaData(MockolateRunnerConstants.MOCK));
						data.mockMetadatas.push(metadata);
					}
					catch (e:Error)
					{
						error = new InitializationError(e.message);
					}
				}
			}
			
			// TODO if there are no [Mock] fields, throw an InitializationError
			// possible causes: no fields marked [Mock] or -keep-as3-metadata doesnt include Mock
			
			parentToken.sendResult(error);
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