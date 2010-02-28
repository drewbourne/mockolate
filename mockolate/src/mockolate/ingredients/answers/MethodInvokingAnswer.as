package mockolate.ingredients.answers
{
    import mockolate.ingredients.Invocation;

    public class MethodInvokingAnswer implements Answer
    {
        private var _target:Object;
        private var _methodName:String;
        
        public function MethodInvokingAnswer(target:Object, methodName:String)
        {
            _target = target;
            _methodName = methodName;
        }

        public function invoke(invocation:Invocation):*
        {
            _target[_methodName].apply(_target, invocation.arguments);            
            return undefined;
        }
    }
}