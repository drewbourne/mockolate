package mockolate.runner.statements
{
	import asx.string.formatToString;
	
	import mockolate.ingredients.Mockolatier;
	import mockolate.nice;
	import mockolate.runner.MockMetadata;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.runner.MockolateRunnerStatement;
	import mockolate.strict;
	
	import org.flexunit.internals.runners.InitializationError;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;

	/**
	 * Creates and injects mock instances to the current testcase instance. 
	 * 
	 * @see mockolate.runner.MockolateRule
	 * @see mockolate.runner.MockolateRunner
	 * 
	 * @author drewbourne
	 */
	public class InjectMockInstances extends MockolateRunnerStatement implements IAsyncStatement
	{
		/**
		 * Constructor. 
		 * @param data
		 */
		public function InjectMockInstances(data:MockolateRunnerData)
		{
			super(data);
		}

		/**
		 * @private
		 */
		public function evaluate(parentToken:AsyncTestToken):void 
		{
			this.parentToken = parentToken;	
			
			var error:Error = null;
			var mockolatier:Mockolatier = data.mockolatier;
			data.mockInstances = [];
			
			try
			{
				for each (var metadata:MockMetadata in data.mockMetadatas)
				{
					if (metadata.injectable)
					{
						var klass:Class = metadata.type;
						var mock:Object 
							= metadata.mockType == "strict" 
							? mockolatier.strict(klass, metadata.name)
							: mockolatier.nice(klass, metadata.name);					
						data.mockInstances.push(mock);					
						data.test[metadata.name] = mock as klass;
					}
				}
			}
			catch (e:Error)
			{
				error = new InitializationError(e.message);
			}
			
			parentToken.sendResult(error);
		}
		
		/**
		 * @private
		 */
		override public function toString():String 
		{
			return formatToString(this, "InjectMockInstances");
		}
	}

}