package
{
	public class ClassInDefaultPackageCanBeMocked
	{
		public var calledSuper:Boolean = false;
		
		public function ClassInDefaultPackageCanBeMocked()
		{
			super();
		}
		
		public function attemptToMockMethod():void 
		{
			calledSuper = true;
		}
	}
}