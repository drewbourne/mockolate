package mockolate.ingredients.bytecode
{
	import org.as3commons.bytecode.interception.IInterceptor;
	import org.as3commons.bytecode.interception.IMethodInvocation;
	
	public class BytecodeInterceptorSupport implements IInterceptor
	{
		private var _callback:Function;
		
		public function BytecodeInterceptorSupport(callback:Function)
		{
			super();
			_callback = callback;
		}
		
		public function intercept(invocation:IMethodInvocation):void
		{
			_callback(invocation);
		}
	}
}