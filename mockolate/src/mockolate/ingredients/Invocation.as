package mockolate.ingredients
{
	import org.hamcrest.SelfDescribing;

	/**
	 * Interface implemented by facades to the invocation objects provide by the proxy factories. 
	 * 
	 * @author drewbourne
	 */
	public interface Invocation extends SelfDescribing
	{
		/**
		 * Object this Invocation was triggered by.
		 */
		function get target():Object;
		
		/**
		 * Name of the Method, Getter or Setter.
		 */
		function get name():String;
		
		/**
		 * Namespace URI.
		 */
		function get uri():String;
		
		/**
		 * InvocationType indicates if this invocation is a Method, Getter or Setter.
		 */
		function get invocationType():InvocationType;
		
		/**
		 * Array of arguments received by this Invocation
		 */
		function get arguments():Array;
		
		/**
		 * Value to return.
		 */
		function get returnValue():*;
		
		function set returnValue(value:*):void;

		/**
		 * Error thrown by this Invocation.
		 */
		function get error():Error;

		function set error(value:Error):void;
		
		/**
		 * Proceed with the original implementation.
		 */
		function proceed():void;
	}
}