package mockolate.ingredients
{	
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	import org.hamcrest.SelfDescribing;
	
	// FIXME Verification is not the most appropriate name for this class.
	[Deprecated(since="0.9.5")]
	/**
	 * Verification. 
	 * 
	 * @see mockolate#verify()
	 * @see mockolate.ingredients.VerifyingCouverture
	 * 
	 * @author drewbourne
	 */
	public class Verification implements SelfDescribing
	{	 
		/**
		 * Constructor. 
		 */
		public function Verification()
		{
		}
		
		/**
		 * When set verifies Invocations with this InvocationType.
		 */
		public function get invocationType():InvocationType
		{
			return _invocationType;
		}
		
		/** @private */
		public function set invocationType(value:InvocationType):void 
		{
			_invocationType = value;
		}
		
		private var _invocationType:InvocationType;
		
		/** @private */
		public function get invocationTypeMatcher():Matcher
		{
			return _invocationTypeMatcher;
		}
		
		/** @private */
		public function set invocationTypeMatcher(value:Matcher):void 
		{
			_invocationTypeMatcher = value;
		}
		
		private var _invocationTypeMatcher:Matcher;
		
		/**
		 * When set verifies Invocations with this name.
		 */
		public function get name():String
		{
			return _name;
		}
		
		/** @private */
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		private var _name:String;
		
		/** @private */
		public function get nameMatcher():Matcher
		{
			return _nameMatcher;
		}
		
		/** @private */
		public function set nameMatcher(value:Matcher):void 
		{
			_nameMatcher = value;
		}
		
		private var _nameMatcher:Matcher;
		
		/**
		 * When set verifies the arguments of Invocations.
		 */
		public function get arguments():Array
		{
			return _arguments;
		}
		
		/** @private */
		public function set arguments(value:Array):void 
		{
			_arguments = value;
		}
		
		private var _arguments:Array;
		
		/** @private */
		public function get argumentsMatcher():Matcher
		{
			return _argumentsMatcher;
		}
		
		/** @private */
		public function set argumentsMatcher(value:Matcher):void 
		{
			_argumentsMatcher = value;
		}
		
		private var _argumentsMatcher:Matcher;
		
		/**
		 * When set verifies Invocations as having been invoked this number of times.
		 */
		public function get invokedCount():String
		{
			return _invokedCount;
		}
		
		/** @private */
		public function set invokedCount(value:String):void 
		{
			_invokedCount = value;
		}
		
		private var _invokedCount:String;
		
		/** @private */
		public function get invokedCountMatcher():Matcher
		{
			return _invokedCountMatcher;
		}
		
		/** @private */
		public function set invokedCountMatcher(value:Matcher):void 
		{
			_invokedCountMatcher = value;
		}
		
		private var _invokedCountMatcher:Matcher;
		
		/**
		 * Describes this Verification to the given Description.
		 */
		public function describeTo(description:Description):void 
		{
			description.appendText(name);
			
			if (invocationType.isMethod)
			{
				description.appendList("(", ", ", ")", this.arguments);
			}
			else if (invocationType.isSetter)
			{
				description
				.appendText(" = ")
					.appendValue(this.arguments[0])
					.appendText(";");
			}
			else if (invocationType.isGetter)
			{
				description.appendText(";");	
			}
		}
	}
}