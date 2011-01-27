package mockolate.ingredients
{
	import asx.array.detect;
	import asx.array.every;
	import asx.fn.callProperty;
	import asx.number.bound;
	import asx.object.isDefined;
	import asx.string.substitute;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	
	import mockolate.ingredients.answers.Answer;
	import mockolate.ingredients.constraints.Constraint;
	
	import org.hamcrest.Matcher;
	import org.hamcrest.StringDescription;
	
	use namespace mockolate_ingredient;
	
	/**
	 * Expectation.
	 * 
	 * @see mockolate#mock()
	 * @see mockolate#stub()
	 * @see mockolate.ingredients.MockingCouverture
	 * 
	 * @author drewbourne
	 */
	public class Expectation
	{
	    /**
	     * Constructor. 
	     */
	    public function Expectation()
	    {
			_constraints = [];
	        _answers = [];
	    }
	    
	    //
	    //	Properties
	    //
	    
	    /**
	     * Name of the method or property this Expectation is for.
	     */
	    public function get name():String 
	    {
	    	return _name;
	    }
	    
	    public function set name(value:String):void
	    {
	    	_name = value;
	    }
	    
	    private var _name:String;
	    
	    /**
	     *  Namespace of the method or property this Expectation is for. 
	     */
	    public function get namespace():String 
	    {
	    	return _namespace;
	    }
	    
	    public function set namespace(value:String):void
	    {
	    	_namespace = value;
	    }
	    
	    private var _namespace:String;
		
		/**
		 * Matcher for the anme of the method or propety this Expectation is for. 
		 */
		public function get nameMatcher():Matcher
		{
			return _nameMatcher;
		}
		
		public function set nameMatcher(value:Matcher):void 
		{
			_nameMatcher = value;
		}
		
		private var _nameMatcher:Matcher;
		
		/**
		 * Type of Invocation: METHOD, GETTER, or SETTER.
		 */
		public function get invocationType():InvocationType
		{
			return _invocationType;
		}
		
		public function set invocationType(value:InvocationType):void 
		{
			_invocationType = value;
		}
		
		private var _invocationType:InvocationType;
		
	    /**
	     * Indicates if this Expectation is for a method.
	     */
	    public function get isMethod():Boolean
	    {
	    	return _invocationType.isMethod;
	    }
	    
		/**
		 * Indicates if this Expectation is for a getter.
		 */
		public function get isGetter():Boolean 
		{
			return _invocationType.isGetter
		}
		
		/**
		 * Indicates if this Expectation is for a getter.
		 */
		public function get isSetter():Boolean 
		{
			return _invocationType.isSetter;
		}
	    
	    /**
	     * Matcher for the invocation arguments.
	     * 
	     * @see #eligible()
	     */
	    public function get argsMatcher():Matcher
	    {
	    	return _argsMatcher;
	    }
	    
	    public function set argsMatcher(value:Matcher):void 
	    {
	    	_argsMatcher = value;
	    }
	    
	    private var _argsMatcher:Matcher;
	    
	    /**
	     * Matcher to check if this Expectation is eligible to be invoked. 
	     * 
	     * @see #eligible()
	     */
	    public function get invokeCountEligiblityMatcher():Matcher 
	    {
	        return _invokeCountEligibilityMatcher;
	    }
	    
	    public function set invokeCountEligiblityMatcher(value:Matcher):void 
	    {
	        _invokeCountEligibilityMatcher = value;
	    }
	    
	    private var _invokeCountEligibilityMatcher:Matcher;
	    
	    /**
	     * Matcher for the number of times this Expectation should be invoked. 
	     * 
	     * @see #verify()
	     */
	    public function get invokeCountVerificationMatcher():Matcher
	    {
	    	return _invokeCountVerificationMatcher;
	    }
	    
	    public function set invokeCountVerificationMatcher(value:Matcher):void 
	    {
	    	_invokeCountVerificationMatcher = value;
	    }
	    
	    private var _invokeCountVerificationMatcher:Matcher;

		/**
	     * Indicates the number of times this Expectation has been invoked. 
	     */
	    public function get invokedCount():int
	    {
	    	return _invokedCount;
	    }
	    
	    mockolate_ingredient function set _invokedCount(value:int):void 
	    {
	    	_invokedCount = value;
	    }
	    
	    private var _invokedCount:int;	    
		
		[ArrayElementType("mockolate.ingredients.constraints.Constraint")]
		/**
		 * Array of Constraints, used to constrain this Expectation to be 
		 * invoked in the correct order. 
		 */
		public function get constraints():Array 
		{
			return _constraints;
		}
		
		mockolate_ingredient function set _constraints(value:Array):void 
		{
			_constraints = value;
		}
		
		private var _constraints:Array;
		
	    [ArrayElementType("mockolate.ingredients.answers.Answer")]
	    /**
	     * Array of Answers, used to determine the returnValue and other 
	     * behaviour when this Expectation is invoked. 
	     * 
	     * @see mockolate.ingredients.answers.Answer
	     */
	    public function get answers():Array
	    {
	    	return _answers.slice();
	    }
	    
	    mockolate_ingredient function set _answers(value:Array):void 
	    {
	    	_answers = value;
	    }
	    
	    private var _answers:Array;
	    
		/**
		 * Indicates if the Expectation has been satisfied. 
		 */
		public function get satisfied():Boolean 
		{
			if (invokeCountVerificationMatcher) 
				return invokeCountVerificationMatcher.matches(invokedCount)
			
			return true;
		}
	    
	    //
	    //	Methods
	    //
		
		/**
		 * Adds a Constraint instance to be used to determine the eligibility of
		 * this Expectation.
		 */
		public function addConstraint(constraint:Constraint):void 
		{
			_constraints.push(constraint);	
		}
	    
	    /**
	     * Adds an Answer instance to be performed when this Expectation is invoked.
	     * 
	     * @see mockolate.ingredients.answers.Answer
	     */
	    public function addAnswer(answer:Answer):void
	    {
	        _answers.push(answer);
	    }
	    
	   	/**
	   	 * Determine if this Expectation is eligible to be invoked for the given Invocation.
	   	 * 
	   	 * @see Invocation
	   	 */
	    public function eligible(invocation:Invocation):Boolean 
	    {
			return eligibleByInvocationType(invocation.invocationType) 
				&& eligibleByName(invocation.name)
				&& eligibleByArguments(invocation.arguments)
				&& eligibleByConstraints()
				&& eligibleByInvocationCount();
	    }
		
		/**
		 * Determines if this Expectation is eligible for the given InvocationType.
		 */		
		protected function eligibleByInvocationType(invocationType:InvocationType):Boolean 
		{
			return this.invocationType == invocationType;	
		}
		
		/**
		 * Determines if this Expectation is eligible for the given method / property name.
		 */		
		protected function eligibleByName(name:String):Boolean 
		{
			return nameMatcher.matches(name);	
		}
		
		/**
		 * Determines if this Expectation is eligible for the given arguments.
		 */		
		protected function eligibleByArguments(arguments:Array):Boolean 
		{
			return !argsMatcher || argsMatcher.matches(arguments);
		}

		/**
		 * Determines if this Expectation is eligible for by its constraints.
		 */		
		protected function eligibleByConstraints():Boolean 
		{
			return every(_constraints, callProperty('isInvocationAllowed'));
		}
		
		/**
		 * Determines if this Expectation is eligible by its invocation count. 
		 */		
		protected function eligibleByInvocationCount():Boolean 
		{
			return !invokeCountEligiblityMatcher 
				|| invokeCountEligiblityMatcher.matches(invokedCount + 1);
		}
		
	    /**
	     * Invokes the Expectation. 
	     * 
	     * Does not check if the Expectation is eligible.
	     *  
	     * Assumes that the Invocation is appropriate for the expected method
	     * or property.
	     */
	    public function invoke(invocation:Invocation):void 
	    {
	    	// increment the number of times this expectation has been invoked
	    	// as it is used when determining if this expectation is eligible to be invoked.
	    	_invokedCount = invokedCount + 1;

			// invoke all the answers to determine the return value 
	        var results:Array = asx.array.invoke(answers, 'invoke', invocation);
	        
	        // use the first result that is not undefined, else undefined.
	        invocation.returnValue = detect(results, isDefined);
	    }
	    
	    /**
	     * Format this Expectation as a String. 
	     */
	    public function toString():String 
	    {
	       return substitute(
	        	isMethod ? "#{}({})" : isSetter ? "#{} = {}" : "#{}",
	        	(namespace ? namespace + "::" : "") + name, 
	        	argsMatcher ? StringDescription.toString(argsMatcher) : "");
	    }
	}
}