package mockolate.ingredients.bytecode
{
	import flash.utils.getQualifiedClassName;

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
			// bytecode sets a QName URI for public members, 
			// mockolate expects the URI to be empty for public members. 
			// FIXME mockolate should do the right thing internally instead of this mess.
			if (member && member.uri.indexOf('::') == -1)
			{
				var fqn:Array = getQualifiedClassName(target).split('::');
				var index:String = member.uri.indexOf(":")
				var prefix:String = member.uri.slice(0, index);
				if (prefix === fqn[0]) 
				{
					member = new QName(null, member.localName);
				}
			}

			trace('BytecodeProxyInterceptor intercept', member, arguments);

			var invocation:Invocation = new BytecodeProxyInvocation(target, kind, member, arguments, method);
			_mockolatier.invoked(invocation);
			return invocation.returnValue;
		}
	}
}