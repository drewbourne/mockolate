package mockolate.runner.statements
{
	import asx.string.formatToString;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.runner.MockolateRunnerStatement;
	
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;
	
	use namespace mockolate_ingredient;
	
	/**
	 * Prepares the proxy classes for classes identified by IdentifyMockClasses. 
	 * 
	 * @see mockolate.runner.MockolateRule
	 * @see mockolate.runner.MockolateRunner
	 * 
	 * @author drewbourne
	 */	
	public class PrepareMockClasses extends MockolateRunnerStatement implements IAsyncStatement
	{
		public function PrepareMockClasses(data:MockolateRunnerData)
		{
			super(data);
		}
		
		public function evaluate(parentToken:AsyncTestToken):void 
		{
			var preparer:IEventDispatcher = data.mockolatier.prepareClassRecipes(data.classRecipes);
			
			preparer.addEventListener(Event.COMPLETE, function(event:Event):void {
				parentToken.sendResult();
			});
		}		
		
		override public function toString():String 
		{
			return formatToString(this, "PrepareMockClasses");
		}
	}
}
