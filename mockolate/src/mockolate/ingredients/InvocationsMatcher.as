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
	import org.hamcrest.core.describedAs;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.number.lessThanOrEqualTo;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.text.re;
	
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
		private var _invocation:InvocationsMatcherInvocation;
		
		/**
		 * Constructor.
		 */
		public function InvocationsMatcher()
		{
			super();
			
			_invocation = new InvocationsMatcherInvocation();
			
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
			_invocation.invocationType = InvocationType.METHOD;
			_invocation.name = name;
			_invocation.nameMatcher = equalTo(name);
			return this;	
		}
		
		/**
		 * Match Invocations for methods with a name that matches the given RegExp.
		 * 
		 * @param regexp RegExp the method name to match.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	assertThat(flavour, received().methods(/^allow/).atLeast(2));
		 * </listing> 
		 */
		public function methods(regexp:RegExp):InvocationsMatcher
		{
			_invocation.invocationType = InvocationType.METHOD;
			_invocation.name = regexp.toString(); 
			_invocation.nameMatcher = re(regexp);
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
			_invocation.invocationType = InvocationType.GETTER;
			_invocation.name = name;
			_invocation.nameMatcher = equalTo(name);
			return this;
		}
		
		/**
		 * 
		 */
		public function getters(regexp:RegExp):InvocationsMatcher
		{
			_invocation.invocationType = InvocationType.GETTER;
			_invocation.name = regexp.toString(); 
			_invocation.nameMatcher = re(regexp);
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
			_invocation.invocationType = InvocationType.SETTER;
			_invocation.name = name;
			_invocation.nameMatcher = equalTo(name);
			return this;
		}
		
		/**
		 * 
		 */
		public function setters(regexp:RegExp):InvocationsMatcher
		{
			_invocation.invocationType = InvocationType.SETTER;
			_invocation.name = regexp.toString(); 
			_invocation.nameMatcher = re(regexp);
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
			_invocation.arguments = rest;
			_invocation.argumentsMatcher = array(map(_invocation.arguments, valueToMatcher));
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
			_invocation.arguments = null;
			_invocation.argumentsMatcher = emptyArray();
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
			_invocation.arguments = null;
			_invocation.argumentsMatcher = arrayWithSize(greaterThanOrEqualTo(0));
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
		public function times(numberOfTimes:int):InvocationsMatcher
		{
			_invocation.invocationCount = numberOfTimes;
			_invocation.invocationCountMatcher = equalTo(numberOfTimes);
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
		public function atLeast(numberOfTimes:int):InvocationsMatcher
		{
			_invocation.invocationCount = numberOfTimes;
			_invocation.invocationCountMatcher = describedAs("at least %0", greaterThanOrEqualTo(numberOfTimes), numberOfTimes);
			
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
		public function atMost(numberOfTimes:int):InvocationsMatcher
		{
			_invocation.invocationCount = numberOfTimes;
			_invocation.invocationCountMatcher = describedAs("at most %0", lessThanOrEqualTo(numberOfTimes), numberOfTimes);
			
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
			
			var invocations:Array = filterInvocations(target);
			
			return arrayWithSize(_invocation.invocationCountMatcher).matches(invocations);
		}
		
		/** @private */
		public function describeMismatch(target:Object, description:Description):void
		{
			var instance:Mockolate = MockolatierMaster.mockolatier.mockolateByTarget(target);
			var invocations:Array = filterInvocations(target);
			
			description
				.appendDescriptionOf(instance)
				.appendText(".")
				.appendDescriptionOf(_invocation);
			
			description
				.appendText(" invoked ")
				.appendText(invocations.length.toString())
				.appendText("/")
				.appendText(_invocation.invocationCount.toString())
				.appendText(" (")
				.appendText(invocations.length > _invocation.invocationCount ? "+" : "")
				.appendText(String(invocations.length - _invocation.invocationCount))
				.appendText(")")
				.appendText(" times");
		}
		
		/** @private */
		public function describeTo(description:Description):void
		{
			description
				.appendDescriptionOf(_invocation.invocationCountMatcher)
				.appendText(" invocations of ")
				.appendDescriptionOf(_invocation);
		}

		/** @private */
		protected function filterInvocations(target:Object):Array 
		{
			var instance:Mockolate = MockolatierMaster.mockolatier.mockolateByTarget(target);
			var invocations:Array = instance.recorder.invocations;			
			var properties:Object = {};
			
			if (_invocation.invocationType)
				properties['invocationType'] = _invocation.invocationType;
			
			if (_invocation.nameMatcher)
				properties['name'] = _invocation.nameMatcher;
			
			if (_invocation.argumentsMatcher)
				properties['arguments'] = _invocation.argumentsMatcher;
			
			var invocationMatcher:Matcher = hasProperties(properties); 			
			var matchingInvocations:Array = filter(invocations, invocationMatcher.matches);
			
			return matchingInvocations;
		}
	}
}
import flash.errors.IllegalOperationError;

import mockolate.errors.MockolateError;
import mockolate.ingredients.AbstractInvocation;
import mockolate.ingredients.Invocation;
import mockolate.ingredients.InvocationType;

import org.hamcrest.Description;
import org.hamcrest.Matcher;

internal class InvocationsMatcherInvocation extends AbstractInvocation implements Invocation
{
	private var _invocationType:InvocationType;
	private var _name:String;
	private var _nameMatcher:Matcher;
	private var _arguments:Array;
	private var _argumentsMatcher:Matcher;
	private var _invocationCount:int;
	private var _invocationCountMatcher:Matcher;
	
	public function InvocationsMatcherInvocation()
	{
		super();
	}
	
	public function get arguments():Array
	{
		return _arguments;
	}
	
	public function set arguments(value:Array):void 
	{
		_arguments = value;
	}

	public function get argumentsMatcher():Matcher
	{
		return _argumentsMatcher;
	}

	public function set argumentsMatcher(value:Matcher):void
	{
		_argumentsMatcher = value;
	}

	public function get invocationCount():int
	{
		return _invocationCount;
	}

	public function set invocationCount(value:int):void
	{
		_invocationCount = value;
	}

	public function get invocationCountMatcher():Matcher
	{
		return _invocationCountMatcher;
	}

	public function set invocationCountMatcher(value:Matcher):void
	{
		_invocationCountMatcher = value;
	}

	public function get invocationType():InvocationType
	{
		return _invocationType;
	}
	
	public function set invocationType(value:InvocationType):void 
	{
		_invocationType = value;
	}

	public function get isGetter():Boolean
	{
		return _invocationType.isGetter;
	}

	public function get isMethod():Boolean
	{
		return _invocationType.isMethod;
	}

	public function get isSetter():Boolean
	{
		return _invocationType.isSetter;
	}

	public function get name():String
	{
		return _name;
	}
	
	public function set name(value:String):void
	{
		_name = value;
	}	

	public function get nameMatcher():Matcher
	{
		return _nameMatcher;
	}

	public function set nameMatcher(value:Matcher):void
	{
		_nameMatcher = value;
	}

	public function proceed():void
	{
		throw new IllegalOperationError("InvocationsMatcherInvocation.proceed() unsupported");
	}

	public function get returnValue():*
	{
		throw new IllegalOperationError("InvocationsMatcherInvocation.returnValue unsupported");
	}

	public function set returnValue(value:*):void
	{
		throw new IllegalOperationError("InvocationsMatcherInvocation.returnValue unsupported");
	}

	public function get target():Object
	{
		throw new IllegalOperationError("InvocationsMatcherInvocation.target unsupported");
		return null;
	}
}