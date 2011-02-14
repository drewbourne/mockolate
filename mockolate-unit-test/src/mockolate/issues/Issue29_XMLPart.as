package mockolate.issues
{
	import mx.messaging.AbstractConsumer;

	public class Issue29_XMLPart
	{
		public function Issue29_XMLPart()
		{
		}
		
		public function set context(value:Issue29_XMLContextPart):void 
		{
			if (value)
				value.useRootNode();
		}
		
		public function add(a:String, b:String):void 
		{
			
		}
		
		public function generate():XML 
		{
			return null;
		}
	}
}