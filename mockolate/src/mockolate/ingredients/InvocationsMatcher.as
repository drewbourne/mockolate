package mockolate.ingredients
{
	import asx.array.filter;
	import asx.array.map;
	
	import flash.utils.getQualifiedClassName;
	
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.core.allOf;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.number.lessThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	
	use namespace mockolate_ingredient;
	
	/**
	 * Matches recorded Invocations for a Mockolate-created Object. 
	 * 
	 * @see mockolate#received()
	 * @see org.hamcrest.Matcher
	 * 
	 * @author drewbourne
	 */
	public class InvocationsMatcher implements Matcher
	{
		private var _invocationType:InvocationType;
		private var _name:String;
		private var _arguments:Array;
		private var _argumentsMatcher:Matcher;
		private var _invocationCount:int;
		private var _invocationCountMatcher:Matcher;
		
		/**
		 * Constructor.
		 */
		public function InvocationsMatcher()
		{
			super();
			
			// default invocation count
			atLeast(1);
		}
		
		//
		//	Spying
		//
		
		public function method(name:String):InvocationsMatcher
		{
			_invocationType = InvocationType.METHOD;
			_name = name;
			return this;	
		}
		
		public function getter(name:String):InvocationsMatcher
		{
			_invocationType = InvocationType.GETTER;
			_name = name;
			return this;
		}
		
		public function setter(name:String):InvocationsMatcher
		{
			_invocationType = InvocationType.SETTER;
			_name = name;
			return this;
		}
		
		/** method() only */
		public function args(...rest):InvocationsMatcher
		{
			_arguments = rest;
			_argumentsMatcher = array(map(_arguments, valueToMatcher));
			return this;
		}
		
		/** method() / getter() only */
		public function noArgs():InvocationsMatcher
		{
			_arguments = null;
			_argumentsMatcher = emptyArray();
			return this;
		}
		
		public function anyArgs():InvocationsMatcher
		{
			_arguments = null;
			_argumentsMatcher = arrayWithSize(greaterThanOrEqualTo(0));
			return this;
		}
		
		/** setter() only */ 
		public function arg(value:*):InvocationsMatcher
		{
			return args(value);
		}
		
		public function times(n:int):InvocationsMatcher
		{
			_invocationCount = n;
			_invocationCountMatcher = equalTo(n);
			return this;
		}
		
		public function never():InvocationsMatcher
		{
			return times(0);
		}
		
		public function once():InvocationsMatcher
		{
			return times(1);
		}
		
		public function twice():InvocationsMatcher
		{
			return times(2);
		}
		
		public function thrice():InvocationsMatcher
		{
			return times(3);
		}
		
		public function atLeast(n:int):InvocationsMatcher
		{
			_invocationCount = n;
			_invocationCountMatcher = greaterThanOrEqualTo(n);
			
			return this;
		}
		
		public function atMost(n:int):InvocationsMatcher
		{
			_invocationCount = n;
			_invocationCountMatcher = lessThanOrEqualTo(n);
			
			return this;
		}
		
		//
		//	Matcher
		//
		
		public function matches(target:Object):Boolean
		{
			var instance:Mockolate = MockolatierMaster.mockolatier.mockolateByTarget(target);
			var invocations:Array = matchInvocations(target);
			
			return arrayWithSize(_invocationCountMatcher).matches(invocations);
		}
		
		public function describeMismatch(target:Object, description:Description):void
		{
			var instance:Mockolate = MockolatierMaster.mockolatier.mockolateByTarget(target);
			var invocations:Array = matchInvocations(target);
			
			var qname:String = getQualifiedClassName(instance.targetClass);
			
			description
				.appendText(qname.slice(qname.lastIndexOf('::') + 2));
			
			if (instance.name)
				description
					.appendText("(")
					.appendText(instance.name)
					.appendText(")");
			
			description
				.appendText(".")
				.appendText(_name);
				
			if (_invocationType.isMethod)
				description
					.appendList("(", ", ", ")", _arguments);
			else if (_invocationType.isSetter)
				description
					.appendText(" = ")
					.appendValue(_arguments[0])
					.appendText(";");
			else if (_invocationType.isGetter)
				description
					.appendText(";");
			
			description
				.appendText(" invoked ")
				.appendText(invocations.length.toString())
				.appendText("/")
				.appendText(_invocationCount.toString())
				.appendText(" (")
				.appendText(invocations.length > _invocationCount ? "+" : "")
				.appendText(String(invocations.length - _invocationCount))
				.appendText(")")
				.appendText(" times");
		}
		
		public function describeTo(description:Description):void
		{
			description
				.appendDescriptionOf(_invocationCountMatcher)
				.appendText(" invocations of ")
				.appendText(_name);
				
			if (_invocationType.isMethod)
				description.appendList("(", ", ", ")", _arguments);
			else if (_invocationType.isSetter)
				description
					.appendText(" = ")
					.appendValue(_arguments[0])
					.appendText(";");
			else if (_invocationType.isGetter)
				description.appendText(";");
		}
		
		protected function matchInvocations(target:Object):Array 
		{
			var instance:Mockolate = MockolatierMaster.mockolatier.mockolateByTarget(target);
			var invocations:Array = instance.recorder.invocations;			
			var properties:Object = {};
			
			if (_invocationType)
				properties['invocationType'] = _invocationType;
			
			if (_name)
				properties['name'] = _name;
			
			if (_argumentsMatcher)
				properties['arguments'] = _argumentsMatcher;
			
			var invocationMatcher:Matcher = hasProperties(properties); 			
			var matchingInvocations:Array = filter(invocations, invocationMatcher.matches);
			
			return matchingInvocations;
		}
	}
}