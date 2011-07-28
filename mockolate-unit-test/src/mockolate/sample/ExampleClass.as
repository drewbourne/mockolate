package mockolate.sample
{
	public class ExampleClass
	{
		public function ExampleClass(num:Number, bool:Boolean, obj:Object, arr:Array)
		{
		}
		
		public function get getter():Boolean 
		{
			return false;	
		}
		
		public function set setter(value:Boolean):void 
		{
		}
		
		for_sample_only function method(num:Number, bool:Boolean, obj:Object, arr:Array, ...rest):Boolean 
		{
			return false;
		}
		
		for_sample_only function get sampleGetter():Boolean 
		{
			return false;
		}
		
		for_sample_only function set sampleSetter(value:Boolean):void 
		{
			
		}
		
		for_sample_only function sampleMethod(num:Number, bool:Boolean, obj:Object, arr:Array, ...rest):Boolean 
		{
			return false;
		}
	}
}