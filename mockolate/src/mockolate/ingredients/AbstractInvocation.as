package mockolate.ingredients
{
	import org.hamcrest.Description;
	import org.hamcrest.SelfDescribing;
	
	/**
	 * Provides default SelfDescribing behaviour for Invocation subclasses.
	 * 
	 * @private
	 * @author drewbourne
	 */
	public class AbstractInvocation implements SelfDescribing
	{
		/**
		 * Constructor.
		 */
		public function AbstractInvocation()
		{
			super();
		}
		
		/**
		 * Describes this Invocation to the given Description.
		 */
		public function describeTo(description:Description):void 
		{
			var invocation:Invocation = (this as Invocation);
			
			if (invocation.uri)
			{
				description.appendText(invocation.uri);
			}
			
			description.appendText(invocation.name);
			
			if (invocation.invocationType.isMethod)
			{
				description.appendList("(", ", ", ")", invocation.arguments || []);
			}
			else if (invocation.invocationType.isSetter)
			{
				description.appendText(" = ");
				
				(invocation.arguments)
					? description.appendValue(invocation.arguments[0])
					: description.appendText("?");
				
				description.appendText(";");
			}
			else if (invocation.invocationType.isGetter)
			{
				description.appendText(";");
			}
		}
	}
}