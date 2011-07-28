package mockolate.runner.statements
{
	import asx.array.forEach;
	import asx.string.formatToString;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mockolate.ingredients.InstanceRecipe;
	import mockolate.ingredients.MockType;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.nice;
	import mockolate.runner.MockMetadata;
	import mockolate.runner.MockolateRunnerData;
	import mockolate.runner.MockolateRunnerStatement;
	import mockolate.strict;
	
	import org.flexunit.internals.runners.InitializationError;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.token.AsyncTestToken;

	use namespace mockolate_ingredient;
	
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
			var preparer:IEventDispatcher = data.mockolatier.prepareInstances(data.instanceRecipes);

			preparer.addEventListener(Event.COMPLETE, function(event:Event):void {
				
				forEach(data.instanceRecipes.toArray(), function(instanceRecipe:InstanceRecipe):void {
					if (instanceRecipe.inject) {
						data.test[instanceRecipe.name] = instanceRecipe.instance;
					}
				});
				
				parentToken.sendResult();
			});
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