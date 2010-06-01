package mockolate.runner.statements
{
	import asx.string.formatToString;
	
	import mockolate.errors.MockolateError;
	import mockolate.runner.MockolateRunnerStatement;
	import mockolate.runner.MockolateRunnerConstants;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.verify;
	
	import org.flexunit.constants.AnnotationConstants;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;
	
	public class VerifyMockInstances extends MockolateRunnerStatement implements IAsyncStatement
	{
		public function VerifyMockInstances(data:MockolateRunnerData)
		{
			super(data);
		}
		
		public function evaluate(parentToken:AsyncTestToken):void 
		{
			this.parentToken = parentToken;	
			
			var error:Error = null;
			
			if (verifyMethod())
			{				
				for each (var mock:Object in data.mockInstances)
				{
					try
					{
						verify(mock);
					}
					catch (e:MockolateError)
					{
						error = e;
						break;
					}
				}
			}
			
			parentToken.sendResult(error);
		}
		
		protected function verifyMethod():Boolean 
		{
			var value:String = data.method.getSpecificMetaDataArgValue(AnnotationConstants.TEST, MockolateRunnerConstants.VERIFY);
			return !value || value == "true";
		}
		
		override public function toString():String 
		{
			return formatToString(this, "VerifyMockInstances");
		}
	}
}