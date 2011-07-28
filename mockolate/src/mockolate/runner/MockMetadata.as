package mockolate.runner
{
	import mockolate.ingredients.MockType;

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
		/**
		 * Name of the field to inject a mock to. 
		 */
		public var name:String;
		
		/**
		 * Class of the mock to inject.
		 */
		public var type:Class;
		
		/**
		 * Type of the mock to inject, "nice" or "strict" or "partial".
		 */
		public var mockType:MockType;
		
		/**
		 * Indicates if the mock should be injected. 
		 */
		public var injectable:Boolean;
		
		/**
		 * Namespaces to proxy.
		 */
		public var namespacesToProxy:Array;
	}
}