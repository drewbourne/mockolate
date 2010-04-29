package mockolate.ingredients.proxy
{
	import flash.errors.IllegalOperationError;
	
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.InvocationType;
	
	public class ProxyInvocation implements Invocation
	{
		private var _target:Object;
		private var _invocationType:InvocationType;
		private var _name:String;
		private var _arguments:Array;
		private var _returnValue:*;
		
		public function ProxyInvocation(
			target:Object,
			invocationType:InvocationType, 
			name:String, 
			arguments:Array)
		{
			_target = target;
			_invocationType = invocationType;
			_name = name;
			_arguments = arguments;
		}
		
		public function get target():Object
		{
			return _target;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get invocationType():InvocationType
		{
			return _invocationType;
		}
		
		public function get isMethod():Boolean
		{
			return _invocationType == InvocationType.METHOD;
		}
		
		public function get isGetter():Boolean
		{
			return _invocationType == InvocationType.GETTER;
		}
		
		public function get isSetter():Boolean
		{
			return _invocationType == InvocationType.SETTER;
		}
		
		public function get arguments():Array
		{
			return _arguments;
		}
		
		public function get returnValue():*
		{
			return _returnValue;
		}
		
		public function set returnValue(value:*):void
		{
			_returnValue = value;
		}
		
		public function proceed():void
		{
			throw new IllegalOperationError("ProxyInvocation.proceed() is unsupported");
		}
	}
}