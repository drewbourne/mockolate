package mockolate.ingredients
{
	import org.hamcrest.Matcher;
	import org.hamcrest.BaseMatcher;

	public class InvocationMatcher extends BaseMatcher
	{
		private var _expected:Invocation;
		private var _expectedArgs:Matcher;

		public function InvocationMatcher(invocation:Invocation, args:Array = null)
		{
			_expected = invocation;
			_expectedArgs = new ArgumentsMatcher(args);
		}

		override public function matches(item:Object):Boolean 
		{
			return matchInvocation(item as Invocation);
		}

		public function matchInvocation(invocation:Invocation):Boolean
		{
			trace('InvocationMatcher', 
				eligibleByInvocationType(invocation),
				eligibleByNamespaceURI(invocation),
				eligibleByName(invocation),
				eligibleByArguments(invocation));

			return eligibleByInvocationType(invocation) 
				&& eligibleByNamespaceURI(invocation)
				&& eligibleByName(invocation)
				&& eligibleByArguments(invocation);
		}
		
		private function eligibleByInvocationType(invocation:Invocation):Boolean 
		{
			return _expected.invocationType === invocation.invocationType;	
		}
		
		private function eligibleByNamespaceURI(invocation:Invocation):Boolean 
		{
			if (_expected.uri && _expected.uri === invocation.uri)
			{
				return true;
			}
			
			if (!_expected.uri && !invocation.uri)
			{
				return true;
			}
				
			return false;
		}
		
		private function eligibleByName(invocation:Invocation):Boolean 
		{
			return _expected.name === invocation.name;
		}
		
		private function eligibleByArguments(invocation:Invocation):Boolean 
		{
			return _expectedArgs.matches(invocation.arguments);
		}
	}
}
