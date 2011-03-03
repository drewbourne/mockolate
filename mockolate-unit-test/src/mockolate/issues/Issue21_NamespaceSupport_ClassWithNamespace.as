package mockolate.issues
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	public dynamic class Issue21_NamespaceSupport_ClassWithNamespace extends Proxy
	{
		public function Issue21_NamespaceSupport_ClassWithNamespace()
		{
			super();
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return true;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return false;
		}
		
		protected var _item:Array; // array of object's properties
		protected var _target:Object = {};
		
		override flash_proxy function nextNameIndex (index:int):int {
			// initial call
			if (index == 0) {
				_item = new Array();
				for (var x:* in _target) {
					_item.push(x);
				}
			}
			
			if (index < _item.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextName(index:int):String {
			return _item[index - 1];
		}
		
		test_namespace function methodInNamespace():Boolean 
		{
			return false;	
		}
		
		test_namespace function get testGetter():Boolean 
		{
			return false;
		}
		
		test_namespace function set testSetter(value:Boolean):void 
		{
			
		}
		
		test_namespace function get defaultValue():int 
		{
			return 42;
		}
		
		test_namespace function getDefaultValue():int 
		{
			return 42;
		}
		
		test_namespace function getProperty(name:String):Object
		{
			return null;
		}
		
		public function publicMethod():Boolean 
		{
			return false;
		}
	}
}