package mockolate.issues.issue35
{
	public class ClassWithConstructorArgs
	{
		public function ClassWithConstructorArgs(required:Boolean)
		{
			if (!required)
			{
				throw new ArgumentError("ClassWithConstructorArgs created with required=false");
			}
		}
	}
}