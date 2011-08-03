package mockolate.issues.issue42
{
	use namespace issue_namespace_1;
	use namespace issue_namespace_2;
	use namespace issue_namespace_3;
	
	public class ClassWithNamespaces
	{
		public function ClassWithNamespaces()
		{
		}
		
		public function isMethodProxied():Boolean 
		{
			return false;
		}
		
		issue_namespace_1 function isNamespacedMethodProxied():Boolean 
		{
			return false;
		}
		
		public function get isGetterProxied():Boolean
		{
			return false;
		}
		
		issue_namespace_1 function get isNamespacedGetterProxied():Boolean 
		{
			return false;
		}
		
		issue_namespace_1 function set isNamespacedSetterProxied(value:Boolean):void 
		{
		}
		
		issue_namespace_2 function set usesIssueNamespace2(value:Boolean):void 
		{
		}
		
		issue_namespace_3 function set usesIssueNamespace3(value:Boolean):void 
		{
		}
	}
}