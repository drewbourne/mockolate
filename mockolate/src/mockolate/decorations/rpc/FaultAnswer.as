package mockolate.decorations.rpc
{
	import flash.utils.setTimeout;
	
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.answers.Answer;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace mx_internal;
	
	/**
	 * Answer that calls AsyncToken#applyFault() to invoke IResponders.  
	 * 
	 * @see HTTPServiceDecorator#fault()
	 *  
	 * @author drewbourne
	 */
	public class FaultAnswer implements Answer 
	{
		private var _token:AsyncToken;
		private var _faultEvent:FaultEvent
		private var _delay:Number;
		
		/**
		 * Constructor.
		 *  
		 * @param token
		 * @param faultEvent
		 * @param delay
		 */
		public function FaultAnswer(token:AsyncToken, faultEvent:FaultEvent, delay:Number = 10)
		{
			_token = token;
			_faultEvent = faultEvent;
			_delay = delay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function invoke(invocation:Invocation):*
		{
			setTimeout(applyFault, _delay);
			
			return undefined;
		}
		
		/**
		 * @private
		 */
		protected function applyFault():void 
		{
			_token.mx_internal::applyFault(_faultEvent);
		}
	}
	

}