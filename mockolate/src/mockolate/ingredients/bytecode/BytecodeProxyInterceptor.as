package mockolate.ingredients.bytecode
{
	import mockolate.ingredients.Couverture;
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.mockolate_ingredient;
	
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	import org.as3commons.bytecode.interception.impl.InvocationKind;
	
	use namespace mockolate_ingredient;
	
	public class BytecodeProxyInterceptor extends Couverture implements IMethodInvocationInterceptor
	{
		private var _mockolatier:Mockolatier;
		
		public function BytecodeProxyInterceptor(mockolate:Mockolate, mockolatier:Mockolatier)
		{
			super(mockolate);
			
			_mockolatier = mockolatier;
		}
		
		public function intercept(target:Object, kind:InvocationKind, member:QName, arguments:Array = null, method:Function = null):*
		{
			var invocation:Invocation = new BytecodeProxyInvocation(target, kind, member, arguments, method);
			_mockolatier.invoked(invocation);
			return invocation.returnValue;
		}
	}
}