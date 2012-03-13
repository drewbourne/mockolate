package mockolate.ingredients.proxy
{
	import flash.errors.IllegalOperationError;
	
	import mockolate.ingredients.AbstractInvocation;
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.InvocationType;
	
	import org.hamcrest.Description;
	
	/**
	 * Invocation created by MockolateProxy.
	 * 
	 * @see mockolate.ingredients.Invocation
	 * 
	 * @author drewbourne
	 */
	public class ProxyInvocation extends AbstractInvocation implements Invocation
	{
		private var _target:Object;
		private var _invocationType:InvocationType;
		private var _name:String;
		private var _arguments:Array;
		private var _returnValue:*;
		private var _uri:String;
		private var _error:Error;
		
		/**
		 * Constructor.
		 * 
		 * @param target Object this Invocation was triggered by.
		 * @param invocationType Indicates if this invocation is a Method, Getter or Setter.
		 * @param name Name of the Method, Getter or Setter.
		 * @param arguments Array of arguments received by this invocation. 
		 */
		public function ProxyInvocation(
			target:Object,
			invocationType:InvocationType, 
			name:String, 
			arguments:Array, 
			uri:String = null)
		{
			_target = target;
			_invocationType = invocationType;
			_name = name;
			_arguments = arguments;
		}
		
		/** @inheritDoc */
		public function get target():Object
		{
			return _target;
		}
		
		/** @inheritDoc */
		public function get name():String
		{
			return _name;
		}
		/** @inheritDoc */
		public function get uri():String 
		{
			return _uri;
		}
		
		/** @inheritDoc */
		public function get invocationType():InvocationType
		{
			return _invocationType;
		}
		
		/** @inheritDoc */
		public function get isMethod():Boolean
		{
			return _invocationType == InvocationType.METHOD;
		}

		/** @inheritDoc */
		public function get isGetter():Boolean
		{
			return _invocationType == InvocationType.GETTER;
		}
		
		/** @inheritDoc */
		public function get isSetter():Boolean
		{
			return _invocationType == InvocationType.SETTER;
		}
		
		/** @inheritDoc */
		public function get arguments():Array
		{
			return _arguments;
		}
		
		/** @inheritDoc */
		public function get returnValue():*
		{
			return _returnValue;
		}
		
		/** @inheritDoc */
		public function set returnValue(value:*):void
		{
			_returnValue = value;
		}

		/** @inheritDoc */
		public function get error():Error
		{
			return _error;
		}
		
		/** @inheritDoc */
		public function set error(value:Error):void
		{
			_error = value;
		}
		
		/** @inheritDoc */
		public function proceed():void
		{
			throw new IllegalOperationError("ProxyInvocation.proceed() is unsupported");
		}
	}
}