package mockolate.issues.issue42
{
	use namespace issue_namespace;
	
	public class ClassWithNamespaces
	{
		public function ClassWithNamespaces()
		{
		}
		
		public function isMethodProxied():Boolean 
		{
			return false;
		}
		
		issue_namespace function isNamespacedMethodProxied():Boolean 
		{
			return false;
		}
		
		public function get isGetterProxied():Boolean
		{
			return false;
		}
		
		issue_namespace function get isNamespacedGetterProxied():Boolean 
		{
			return false;
		}
		
		issue_namespace function set isNamespacedSetterProxied(value:Boolean):void 
		{
			
		}
	}
}