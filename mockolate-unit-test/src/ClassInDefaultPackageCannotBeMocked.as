package
{
	public class ClassInDefaultPackageCannotBeMocked
	{
		public var calledSuper:Boolean = false;
		
		public function ClassInDefaultPackageCannotBeMocked()
		{
			super();
		}
		
		public function attemptToMockMethod():void 
		{
			calledSuper = true;
		}
	}
}