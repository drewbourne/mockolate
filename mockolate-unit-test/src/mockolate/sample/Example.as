package mockolate.sample
{
	import flash.events.IEventDispatcher;
	
	public interface Example extends IEventDispatcher
	{
		function acceptNumber( value:Number ):void;
		function giveString():String;
		function optional( ...rest ):void
		
		function justCall():void;
		function dispatchMyEvent():void;
		function callWithRest(...rest):void;
	}
}
