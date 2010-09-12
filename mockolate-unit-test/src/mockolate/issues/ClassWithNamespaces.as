package mockolate.issues
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	public class ClassWithNamespaces extends Proxy
	{
		public function ClassWithNamespaces()
		{
			super();
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return true;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return true;
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
		
		public function publicMethod():Boolean 
		{
			return false;
		}
	}
}