package mockolate.runner
{
	import asx.array.contains;
	import asx.string.substitute;

	import flex.lang.reflect.Klass;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;

	[ExcludeClass]
	/**
	 * MockMetadata is used by the MockolateRunner and MockolateRule.
	 *
	 * Set to ExludeClass to make using mock(instance) easier to select from the
	 * auto complete list.
	 * 
	 * @see mockolate.runner.MockolateRule
	 * @see mockolate.runner.MockolateRunner
	 */
	public class MockMetadata
	{
		private const MOCK_TYPE_ARGUMENT:String = "type";
		private const INJECT_ARGUMENT:String = "inject";

		/**
		 * Name of the field to inject a mock to. 
		 */
		public var name:String;
		
		/**
		 * Class of the mock to inject.
		 */
		public var type:Class;
		
		/**
		 * Type of the mock to inject, "nice" or "strict"
		 */
		public var mockType:String;
		
		/**
		 * Indicates if the mock should be injected. 
		 */
		public var injectable:Boolean;

		/**
		 * Constructor.
		 * 
		 * @param name
		 * @param type
		 * @param metadata 
		 */
		public function MockMetadata(name:String, type:Class, metadata:MetaDataAnnotation)
		{
			this.name = name;
			this.type = type;
			this.mockType = parseMockType(metadata.getArgument(MOCK_TYPE_ARGUMENT));
			this.injectable = parseInject(metadata.getArgument(INJECT_ARGUMENT));
		}

		/**
		 * @private
		 */
		protected function parseMockType(argument:MetaDataArgument):String
		{
			const NICE:String = "nice";
			const STRICT:String = "strict";

			//default value
			var result:String = argument ? argument.value : NICE;

			//possible string values
			if (!contains([ NICE, STRICT ], result))
			{
				var message:String = substitute("Property '{}' must declare a mock type of either 'nice' or 'strict'; '{}' is NOT a valid type.", this.name, result);
				throw new Error(message);
			}

			return result;
		}

		/**
		 * @private
		 */
		protected function parseInject(argument:MetaDataArgument):Boolean
		{
			const TRUE:String = "true";
			const FALSE:String = "false";

			//default value
			var result:Boolean;
			var injectableValue:String = argument ? argument.value : TRUE;

			//possible string values
			if (!contains([ TRUE, FALSE ], injectableValue))
			{
				throw new Error(substitute(
					"Property '{}' must declare the attribute inject as either "
					+ "'true' or 'false'; '{}' is NOT valid.",
					this.name, result));
			}

			result = injectableValue == TRUE;

			return result;
		}
	}
}