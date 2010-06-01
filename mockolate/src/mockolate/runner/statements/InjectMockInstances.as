package mockolate.runner.statements
{
	import asx.string.formatToString;
	
	import mockolate.nice;
	import mockolate.runner.MockMetadata;
	import mockolate.runner.MockolateRunnerStatement;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.strict;
	
	import org.flexunit.internals.runners.InitializationError;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;
	
	public class InjectMockInstances extends MockolateRunnerStatement implements IAsyncStatement
	{
		public function InjectMockInstances(data:MockolateRunnerData)
		{
			super(data);
		}
		
		public function evaluate(parentToken:AsyncTestToken):void 
		{
			this.parentToken = parentToken;	
			
			var error:Error = null;
			
			data.mockInstances = [];
			
			try
			{
				for each (var metadata:MockMetadata in data.mockMetadatas)
				{
					if (metadata.injectable)
					{
						var klass:Class = metadata.type;
						var mock:Object = metadata.mockType == "strict" ? strict(klass) : nice(klass);					
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
		
		override public function toString():String 
		{
			return formatToString(this, "InjectMockInstances");
		}
	}

}