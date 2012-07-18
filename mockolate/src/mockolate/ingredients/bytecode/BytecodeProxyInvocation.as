package mockolate.ingredients.bytecode
{
	import mockolate.errors.MockolateError;
	import mockolate.ingredients.AbstractInvocation;
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.InvocationType;
	
	import org.as3commons.bytecode.interception.impl.InvocationKind;
	
	public class BytecodeProxyInvocation extends AbstractInvocation implements Invocation
	{
		private var _target:Object;
		private var _invocationKind:InvocationKind;
		private var _invocationType:InvocationType;
		private var _member:QName;
		private var _arguments:Array;
		private var _method:Function;
		private var _returnValue:*;
		private var _error:Error;
		
		public function BytecodeProxyInvocation(targetInstance:Object, kind:InvocationKind, member:QName, arguments:Array = null, method:Function = null)
		{
			_target = targetInstance;
			_invocationKind = kind;
			_invocationType = invocationTypeFromInvocationKind(kind);
			_member = member;
			_arguments = arguments;
			_method = method;
		}
		
		public function get target():Object
		{
			return _target;
		}
		
		public function get name():String
		{
			return _member.localName;
		}
		
		public function get uri():String 
		{
			return _member.uri;
		}
		
		public function get invocationType():InvocationType
		{
			return _invocationType;
		}
		
		public function get isConstructor():Boolean 
		{
			return _invocationType.isConstructor;
		}
		
		public function get isMethod():Boolean
		{
			return _invocationType.isMethod;
		}
		
		public function get isGetter():Boolean
		{
			return _invocationType.isGetter;
		}
		
		public function get isSetter():Boolean
		{
			return _invocationType.isSetter;
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

		public function get error():Error
		{
			return _error;
		}
		
		public function set error(value:Error):void
		{
			_error = value;
		}
		
		public function proceed():void
		{
			if (_method != null)
			{
				returnValue = _method.apply(null, _arguments);
			}
		}
		
		private function invocationTypeFromInvocationKind(invocationKind:InvocationKind):InvocationType
		{
			switch (invocationKind)
			{
				case InvocationKind.METHOD:
					return InvocationType.METHOD;
					break;
				
				case InvocationKind.GETTER:
					return InvocationType.GETTER;
					break;	
				
				case InvocationKind.SETTER:
					return InvocationType.SETTER;
					break;
				
				case InvocationKind.CONSTRUCTOR:
					return InvocationType.CONSTRUCTOR;
					break;
				
				default: 
					throw new MockolateError("Unknown InvocationKind " + invocationKind, null, target);
			}
			
			
		}
	}
}