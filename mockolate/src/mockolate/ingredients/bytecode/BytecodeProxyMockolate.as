package mockolate.ingredients.bytecode
{
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.mockolate_ingredient;
	
	import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
	
	public class BytecodeProxyMockolate extends Mockolate
	{
		mockolate_ingredient var interceptor:IMethodInvocationInterceptor;
		
		public function BytecodeProxyMockolate(name:String=null)
		{
			super(name);
		}
	}
}