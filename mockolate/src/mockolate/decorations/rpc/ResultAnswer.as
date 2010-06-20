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
	 * Answer that calls AsyncToken#applyResult() to invoke IResponders.  
	 * 
	 * @see HTTPServiceDecorator#result()
	 *  
	 * @author drewbourne
	 */
	public class ResultAnswer implements Answer 
	{
		private var _token:AsyncToken;
		private var _resultEvent:ResultEvent
		private var _delay:Number;
		
		/**
		 * Constructor.
		 */
		public function ResultAnswer(token:AsyncToken, resultEvent:ResultEvent, delay:Number = 10)
		{
			_token = token;
			_resultEvent = resultEvent;
			_delay = delay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function invoke(invocation:Invocation):*
		{
			setTimeout(applyResult, _delay);
			
			return undefined;
		}
		
		/**
		 * @private
		 */
		protected function applyResult():void 
		{
			_token.mx_internal::applyResult(_resultEvent);
		}
	}
}