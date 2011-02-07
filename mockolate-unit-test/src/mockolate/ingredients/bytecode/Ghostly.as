package mockolate.ingredients.bytecode
{
	public interface Ghostly
	{
		function get readOnly():Boolean;
		
		function get readWrite():Array;
		function set readWrite(value:Array):void;
		
		function set isSeethrough(value:Boolean):void;
		
		function toString():String;
	}
}