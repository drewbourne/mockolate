package
{
	public class ClassInDefaultPackageCanBeMocked
	{
		public function ClassInDefaultPackageCanBeMocked()
		{
			super();
		}
		
		public function attemptToMockMethod():Boolean 
		{
			return false;
		}
		
		public function get attemptToMockGetter():Boolean 
		{
			return false;
		}
	}
}