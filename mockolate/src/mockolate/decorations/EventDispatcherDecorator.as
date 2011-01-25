package mockolate.decorations
{
	import asx.array.contains;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mockolate.errors.MockolateError;
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.InvocationType;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.answers.MethodInvokingAnswer;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace mockolate_ingredient;

	/**
	 * Decorates the MockingCouverture with expectations specific to IEventDispatcher.
	 * 
	 * @see mockolate.ingredients.MockingCouverture#asEventDispatcher() 
	 */
	public class EventDispatcherDecorator extends Decorator
	{
		private var _usingProxyEventDispatcher:Boolean;
		private var _eventDispatcher:IEventDispatcher;
		private var _eventDispatcherMethods:Array = [
			'addEventListener', 
			'dispatchEvent', 
			'hasEventListener', 
			'removeEventListener', 
			'willTrigger'
			];
		
		/**
		 * Constructor.
		 * 
		 * @param mockolate Mockolate instance 
		 */
		public function EventDispatcherDecorator(mockolate:Mockolate)
		{
			super(mockolate);
			
			initialize();
		}
		
		/**
		 * IEventDispatcher that will be used to dispatch events. 
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		/**
		 * Initialize the <code>eventDispatcher</code>
		 */		
		protected function initialize():void 
		{
			if (this.mockolate.target is DisplayObject)
				initializeForDisplayObject();
			else if (this.mockolate.target is EventDispatcher)
				initializeForEventDispatcher();
			else if (this.mockolate.target is IEventDispatcher)
				initializeForIEventDispatcher();
			else
				throw new MockolateError(["Mockolate target is not an IEventDispatcher, target: {}", [mockolate.target]], mockolate, mockolate.target);
		}
		
		/**
		 * Initializes the <code>eventDispatcher</code> for an IEventDispatcher.
		 */
		protected function initializeForIEventDispatcher():void 
		{
			_eventDispatcher = new EventDispatcher(this.mockolate.target);
			_usingProxyEventDispatcher = true;
			
			for each (var methodName:String in _eventDispatcherMethods)
			{
				mocker.method(methodName).answers(new MethodInvokingAnswer(_eventDispatcher, methodName));    
			}
		}
		
		/**
		 * Initializes the <code>eventDispatcher</code> for an EventDispatcher.
		 */
		protected function initializeForEventDispatcher():void 
		{
			_eventDispatcher = this.mockolate.target as IEventDispatcher;
			_usingProxyEventDispatcher = false;
			
			for each (var methodName:String in _eventDispatcherMethods)
			{
				mocker.method(methodName).callsSuper();
			}
		}
		
		/**
		 * Initializes the <code>eventDispatcher</code> for a DisplayObject.
		 */
		protected function initializeForDisplayObject():void 
		{
			_eventDispatcher = this.mockolate.target as IEventDispatcher;
			_usingProxyEventDispatcher = false;
			
			for each (var methodName:String in _eventDispatcherMethods)
			{
				mocker.method(methodName).callsSuper();    
			}
		}
	}
}