package mockolate.ingredients
{
	import asx.string.formatToString;
	
	import mockolate.errors.MockolateError;

	public class ClassRecipe
	{
		public var classToPrepare:Class;
		
		public var namespacesToProxy:Array; // Vector.<Namespace>;
		
		public var proxyClass:Class;
		
		public function matches(classReference:Class, namespaces:Array):Boolean 
		{
			return matchesClass(classReference)
				&& matchesNamespaces(namespaces);
		}
		
		private function matchesClass(classReference:Class):Boolean 
		{
			return classToPrepare == classReference;
		}
		
		private function matchesNamespaces(namespaces:Array):Boolean 
		{
			if (!namespacesToProxy && !namespaces)
			{
				return true;
			}
			
			if (namespacesToProxy && !namespaces)
			{
				return (namespacesToProxy.length == 0);
			}
			
			if (!namespacesToProxy && namespaces)
			{
				return (namespaces.length == 0);
			}
			
			if (namespacesToProxy.length != namespaces.length)
			{
				return false;
			}
				
			for each (var namespace:Namespace in namespacesToProxy) 
			{
				if (namespaces.indexOf(namespace) == -1)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public function toString():String 
		{
			return formatToString(this, "ClassRecipe", [ "classToPrepare", "namespacesToProxy", "proxyClass" ]);
		}
	}
}