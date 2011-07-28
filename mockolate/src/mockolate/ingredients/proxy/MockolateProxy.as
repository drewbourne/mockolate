package mockolate.ingredients.proxy
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mockolate.ingredients.InvocationType;
	import mockolate.ingredients.MockType;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.MockolatierMaster;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace flash_proxy;
	use namespace mockolate_ingredient;

	/**
	 * MockolateProxy is for situations where a generated Mockolate proxy 
	 * may not be possible. Methods, Getters and Setters can be called on the 
	 * proxy with the same name and arguments or use <code>invokeMethod</code>, 
	 * <code>invokeGetter</code> and <code>invokeSetter</code>.
	 * 
	 * For <code>...rest</code> arguments use <code>invokeMethod</code>.
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	public class FlavourMock implements Flavour
	 * 	{
	 * 		public var proxy:MockolateProxy;
	 * 
	 * 		public function FlavourMock()
	 * 		{
	 * 			proxy = new MockolateProxy();
	 * 		}
	 * 
	 * 		public function get name():String 
	 *	 	{
	 * 			return proxy.name;
	 *		}
	 * 
	 * 		public function get ingredients():Array
	 * 		{
	 * 			return proxy.ingredients;
	 * 		}
	 * 
	 * 		public function set ingredients(value:Array):void 
	 * 		{
	 * 			proxy.ingredients = value;
	 * 		}
	 * 
	 * 		public function set liked(value:Boolean):void 
	 * 		{
	 * 			proxy.liked = value;
	 * 		}
	 * 
	 * 		public function combine(flavour:Flavour, ... otherFlavours):Flavour
	 * 		{
	 * 			proxy.mockolate_ingredient::invokeMethod('combine', [flavour].concat(otherFlavours));
	 * 		}
	 * 
	 * 		public function toString():String 
	 * 		{
	 * 			return proxy.toString();
	 * 		}
	 * 	}
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public dynamic class MockolateProxy extends Proxy 
	{
		private var _mockolate:Mockolate;
		private var _target:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param target
		 * @param asStrict
		 * @param name
		 */
		public function MockolateProxy(mockType:MockType, target:Object, name:String=null)
		{
			_mockolate = new ProxyMockolateFactory().create(mockType, Class(getDefinitionByName(getQualifiedClassName(target))), null, name);
			_mockolate.target = _target = target;
			
			MockolatierMaster.mockolatier.registerTargetMockolate(_target, _mockolate);
		}
		
		/**
		 * Invoke a Method.
		 */
		public function invokeMethod(name:*, args:Array):*
		{
			var invocation:ProxyInvocation = new ProxyInvocation(_target, InvocationType.METHOD, name, args);
			
			_mockolate.invoked(invocation);
			
			return invocation.returnValue;
		}
		
		/**
		 * Invoke a Getter.
		 */
		public function invokeGetter(name:*):*
		{
			var invocation:ProxyInvocation = new ProxyInvocation(_target, InvocationType.GETTER, name, null);
			
			_mockolate.invoked(invocation);
			
			return invocation.returnValue;
		}
		
		/**
		 * Invoke a Setter.
		 */
		public function invokeSetter(name:*, value:*):void
		{
			var invocation:ProxyInvocation = new ProxyInvocation(_target, InvocationType.SETTER, name, [value]);
			
			_mockolate.invoked(invocation);
		}
		
		/**
		 * Handle a method invocation.
		 */
		override flash_proxy function callProperty(name:*, ...args):*
		{
			return invokeMethod(name, args);
		}
		
		/**
		 * Handle a property getter invocation.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			return invokeGetter(name)
		}
		
		/**
		 * Handle a property setter invocation.
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			invokeSetter(name, value);
		}
		
		/**
		 * Indicates if the property exists on this object.
		 * 
		 * @return <code>false</code>
		 */
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