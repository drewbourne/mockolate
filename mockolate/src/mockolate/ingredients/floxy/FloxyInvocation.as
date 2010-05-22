package mockolate.ingredients.floxy
{
    import asx.string.formatToString;
    
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.InvocationType;
    
    import org.floxy.IInvocation;
    
    /**
     * Wraps the FLoxy IInvocation type in the Mockolate Invocation interface.
     * 
     * @author drewbourne. 
     */
    public class FloxyInvocation implements Invocation
    {
        private var _invocation:IInvocation;
        private var _invocationType:InvocationType;
        
        /**
         * Constructor. 
         */
        public function FloxyInvocation(invocation:IInvocation)
        {
            _invocation = invocation;
            _invocationType = invocationTypeFromInvocation(invocation); 
        }
        
        public function get target():Object
        {
            return _invocation.invocationTarget;
        }
        
        public function get name():String
        {
            return isMethod
                ? _invocation.method.name
                : _invocation.property.name
        }
        
        public function get invocationType():InvocationType
        {
            return _invocationType;
        }
        
        public function get isMethod():Boolean
        {
            return _invocationType.isMethod;
        }
        
        public function get isGetter():Boolean
        {
            return _invocationType.isGetter;
        }
        
        public function get isSetter():Boolean
        {
            return _invocationType.isSetter;
        }
        
        public function get arguments():Array
        {
            return _invocation.arguments;
        }
        
        public function get returnValue():*
        {
            return _invocation.returnValue;
        }
        
        public function set returnValue(value:*):void
        {
            _invocation.returnValue = value;
        }
        
        public function proceed():void
        {
            _invocation.proceed();
        }
        
        public function toString():String 
        {
            return formatToString(this, "FloxyInvocation", ["invocationType", "name", "arguments"]);
        }
		
		protected function invocationTypeFromInvocation(invocation:IInvocation):InvocationType 
		{
			var invocationType:InvocationType;
			
			if (invocation.property)
			{
				if (invocation.method.name == "get")
				{
					invocationType = InvocationType.GETTER;
				}
				else if (_invocation.method.name == "set")
				{
					invocationType = InvocationType.SETTER;
				}
			}
			else
			{
				invocationType = InvocationType.METHOD;
			}
			
			return invocationType;
		}
    }
}