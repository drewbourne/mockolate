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
	 * @example
	 * <listing version="3.0">
	 * 	[Test]
	 * 	public function iSpyWithMyLittleEye():void 
	 * 	{
	 * 		var flavour:Flavour = nice(Flavour);
	 * 		var otherFlavour:Flavour = nice(Flavour);
     *
     * 		// ... do some work with the instances.
	 * 
	 * 		// check that flavour.name was called at all.
	 * 		assertThat(flavour, received().method('name'));
	 * 
	 * 		// check that flavour.combine() was called with any args
	 * 		assertThat(flavour, received().method('combine').args(anything()));
	 * 
	 * 		// check that flavour.combine() was called with a specific instance of flavour
	 * 		assertThat(flavour, received().method('combine').args(strictlyEqualTo(otherFlavour)));
	 * 
	 * 		// check that flavour.combine() was called with a number of flavours, any instance.
	 * 		assertThat(flavour, received().method('combine').args(instanceOf(DarkChocolate), instanceOf(Flavour)));
	 * 
	 *		// check that flavour.combine() was called at least 3 times
	 * 		assertThat(flavour, received().method('combine').atLeast(3));
	 * 
	 * 		// check that flavour.combine() was never called
	 * 		assertThat(flavour, received().method('combine').args(Curry, IceCream).never());
	 * 	}
	 * </listing>
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
		
		/**
		 * Match Invocations for the given method name.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine"));
		 * </listing>
		 */
		public function method(name:String):InvocationsMatcher
		{
			_invocationType = InvocationType.METHOD;
			_name = name;
			return this;	
		}
		
		/**
		 * Match Invocations for the given property getter name.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().getter("ingredients));
		 * </listing>
		 */
		public function getter(name:String):InvocationsMatcher
		{
			_invocationType = InvocationType.GETTER;
			_name = name;
			return this;
		}
		
		/**
		 * Match Invocations for the given property setter name.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().setter("ingredients"));
		 * </listing>
		 */
		public function setter(name:String):InvocationsMatcher
		{
			_invocationType = InvocationType.SETTER;
			_name = name;
			return this;
		}
		
		/**
		 * Match Invocations for with the given arguments. Accepts values or matchers.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").args(Flavour));
		 * </listing>
		 */
		public function args(...rest):InvocationsMatcher
		{
			_arguments = rest;
			_argumentsMatcher = array(map(_arguments, valueToMatcher));
			return this;
		}
		
		/**
		 * Match Invocations for with no arguments.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("toString").noArgs());
		 * </listing>
		 */
		public function noArgs():InvocationsMatcher
		{
			_arguments = null;
			_argumentsMatcher = emptyArray();
			return this;
		}
		
		/**
		 * Match Invocations for with any arguments.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").anyArgs());
		 * </listing>
		 */
		public function anyArgs():InvocationsMatcher
		{
			_arguments = null;
			_argumentsMatcher = arrayWithSize(greaterThanOrEqualTo(0));
			return this;
		}
		
		/**
		 * Match Invocations for with a single argument that matches the given value or Matcher.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").arg(Flavour));
		 * </listing>
		 */ 
		public function arg(value:*):InvocationsMatcher
		{
			return args(value);
		}
		
		/**
		 * Match Invocations for the given count. 
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").times(2));
		 * </listing>
		 */
		public function times(n:int):InvocationsMatcher
		{
			_invocationCount = n;
			_invocationCountMatcher = equalTo(n);
			return this;
		}
		
		/**
		 * Match Invocations if they have never been called.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").never());
		 * </listing>
		 */
		public function never():InvocationsMatcher
		{
			return times(0);
		}
		
		/**
		 * Match Invocations if they have been called once.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").never());
		 * </listing>
		 */
		public function once():InvocationsMatcher
		{
			return times(1);
		}
		
		/**
		 * Match Invocations if they have been called twice.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").twice());
		 * </listing>
		 */
		public function twice():InvocationsMatcher
		{
			return times(2);
		}
		
		/**
		 * Match Invocations if they have been called thrice.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").thrice());
		 * </listing>
		 */
		public function thrice():InvocationsMatcher
		{
			return times(3);
		}
		
		/**
		 * Match Invocations if they have been called at least the given number of times.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").atLeast(3));
		 * </listing>
		 */
		public function atLeast(n:int):InvocationsMatcher
		{
			_invocationCount = n;
			_invocationCountMatcher = greaterThanOrEqualTo(n);
			
			return this;
		}
		
		/**
		 * Match Invocations if they have been called at most the given number of times.  
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assetThat(flavour, received().method("combine").atLeast(4));
		 * </listing>
		 */
		public function atMost(n:int):InvocationsMatcher
		{
			_invocationCount = n;
			_invocationCountMatcher = lessThanOrEqualTo(n);
			
			return this;
		}
		
		//
		//	Matcher
		//
		
		/** @private */
		public function matches(target:Object):Boolean
		{
			// mockolateByTarget will throw a MockolateError if there is no Mockolate for the target.  
			MockolatierMaster.mockolatier.mockolateByTarget(target);
			
			var invocations:Array = matchInvocations(target);
			
			return arrayWithSize(_invocationCountMatcher).matches(invocations);
		}
		
		/** @private */
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
				
			describeInvocationTo(description);
			
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
		
		/** @private */
		public function describeTo(description:Description):void
		{
			description
				.appendDescriptionOf(_invocationCountMatcher)
				.appendText(" invocations of ")
				.appendText(_name);
				
			describeInvocationTo(description);
		}

		/** @private */
		protected function describeInvocationTo(description:Description):void
		{
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

		/** @private */
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