package mockolate.sample
{
	public class ClassWithConstructorGetter
	{
		public function ClassWithConstructorGetter(value:Object)
		{
		}
		
		// shadows Object.constructor
		public function get constructor():Object 
		{
			return null;
		}
	}
}