package mockolate.ingredients
{
	import asx.string.formatToString;

	use namespace mockolate_ingredient;

	public class InstanceRecipe
	{
		public var classRecipe:ClassRecipe;
		public var constructorArgs:Array;
		public var constructorArgsFunction:Function;
		public var mockType:MockType;
		public var name:String;
		public var inject:Boolean = true;
		
		public var instance:*;
		public var mockolate:Mockolate;
		
		public function toString():String
		{
			return formatToString(this, "InstanceRecipe", ["classRecipe", "name", "mockType", "inject", "constructorArgs"]);
		}
	}
}