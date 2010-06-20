package mockolate.ingredients.answers
{
    import mockolate.ingredients.Invocation;

	/**
	 * Invokes a method by name on a target object when an invoked.
	 * 
	 * @author drewbourne
	 */
    public class MethodInvokingAnswer implements Answer
    {
        private var _target:Object;
        private var _methodName:String;
        
		/**
		 * Constructor.
		 * 
		 * @param target
		 * @param methodName
		 */
        public function MethodInvokingAnswer(target:Object, methodName:String)
        {
            _target = target;
            _methodName = methodName;
        }

		/**
		 * @inheritDoc
		 */
        public function invoke(invocation:Invocation):*
        {
            _target[_methodName].apply(_target, invocation.arguments);            
            return undefined;
        }
    }
}