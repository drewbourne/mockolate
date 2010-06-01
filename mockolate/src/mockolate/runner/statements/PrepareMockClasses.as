package mockolate.runner.statements
{
	import asx.array.compact;
	import asx.array.pluck;
	import asx.array.unique;
	import asx.string.formatToString;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mockolate.prepare;
	import mockolate.runner.MockolateRunnerStatement;
	import mockolate.runner.MockolateRunnerData;
	
	import org.flexunit.internals.runners.InitializationError;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;
	
	public class PrepareMockClasses extends MockolateRunnerStatement implements IAsyncStatement
	{
		public function PrepareMockClasses(data:MockolateRunnerData)
		{
			super(data);
		}
		
		public function evaluate(parentToken:AsyncTestToken):void 
		{
			this.parentToken = parentToken;	
			
			var error:Error = null;
			var classes:Array = compact(unique(pluck(data.mockMetadatas, 'type')));
			
			try 
			{
				var preparer:IEventDispatcher = prepare(classes);			
				preparer.addEventListener(Event.COMPLETE, prepareComplete);
			}
			catch (e:Error)
			{
				error = new InitializationError(e.message);	
				parentToken.sendResult(error);
			}
		}
		
		protected function prepareComplete(event:Event):void 
		{
			event.target.removeEventListener(Event.COMPLETE, arguments.callee);
			
			parentToken.sendResult();
		}
		
		override public function toString():String 
		{
			return formatToString(this, "PrepareMockClasses");
		}
	}
}