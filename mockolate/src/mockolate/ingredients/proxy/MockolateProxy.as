package mockolate.ingredients.proxy
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mockolate.ingredients.InvocationType;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.MockolatierMaster;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace flash_proxy;
	use namespace mockolate_ingredient;

	public dynamic class MockolateProxy extends Proxy 
	{
		private var _mockolate:Mockolate;
		private var _target:Object;
		
		public function MockolateProxy(target:Object, asStrict:Boolean=true, name:String=null)
		{
			_mockolate = new ProxyMockolateFactory().create(Class(getDefinitionByName(getQualifiedClassName(target))), null, asStrict, name);
			_mockolate.target = _target = target;
			
			MockolatierMaster.registerTargetMockolate(_target, _mockolate);
		}
		
		mockolate_ingredient function invokeMethod(name:*, args:Array):*
		{
			var invocation:ProxyInvocation = new ProxyInvocation(_target, InvocationType.METHOD, name, args);
			
			_mockolate.invoked(invocation);
			
			return invocation.returnValue;
		}
		
		mockolate_ingredient function invokeGetter(name:*):*
		{
			var invocation:ProxyInvocation = new ProxyInvocation(_target, InvocationType.GETTER, name, null);
			
			_mockolate.invoked(invocation);
			
			return invocation.returnValue;
		}
		
		mockolate_ingredient function invokeSetter(name:*, value:*):void
		{
			var invocation:ProxyInvocation = new ProxyInvocation(_target, InvocationType.SETTER, name, [value]);
			
			_mockolate.invoked(invocation);
		}
		
		override flash_proxy function callProperty(name:*, ...args):*
		{
			return invokeMethod(name, args);
		}
		
		// property get requests
		override flash_proxy function getProperty(name:*):*
		{
			return invokeGetter(name)
		}
		
		// property set requests
		override flash_proxy function setProperty(name:*, value:*):void
		{
			invokeSetter(name, value);
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return false;	
		}
		
		//	override flash_proxy function nextName( index:int ):String
		//	{
		//		return null;
		//	}
		//	
		//	override flash_proxy function nextNameIndex( index:int ):int
		//	{
		//		return 0;
		//	}
		//	
		//	override flash_proxy function nextValue( index:int ):*
		//	{
		//		return int(0);
		//	}
	}

}