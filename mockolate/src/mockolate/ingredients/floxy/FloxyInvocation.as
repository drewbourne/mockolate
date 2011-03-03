package mockolate.ingredients.floxy
{
    import asx.string.formatToString;
    
    import mockolate.ingredients.AbstractInvocation;
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.InvocationType;
    
    import org.floxy.IInvocation;
    import org.hamcrest.Description;
    
    /**
     * Wraps the FLoxy IInvocation type in the Mockolate Invocation interface.
     * 
     * @author drewbourne. 
     */
    public class FloxyInvocation extends AbstractInvocation implements Invocation
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
        
		/** @inheritDoc */
        public function get target():Object
        {
            return _invocation.invocationTarget;
        }
        
		/** @inheritDoc */
        public function get name():String
        {
            return isMethod
                ? _invocation.method.name
                : _invocation.property.name
        }
		
		/** @inheritDoc */
		public function get uri():String 
		{
			return isMethod 
				? _invocation.method.ns
				: _invocation.property.ns;
		}
        
		/** @inheritDoc */
        public function get invocationType():InvocationType
        {
            return _invocationType;
        }
        
		/** @inheritDoc */
        public function get isMethod():Boolean
        {
            return _invocationType.isMethod;
        }
        
		/** @inheritDoc */
        public function get isGetter():Boolean
        {
            return _invocationType.isGetter;
        }
        
		/** @inheritDoc */
        public function get isSetter():Boolean
        {
            return _invocationType.isSetter;
        }
        
		/** @inheritDoc */
        public function get arguments():Array
        {
            return _invocation.arguments;
        }
        
		/** @inheritDoc */
        public function get returnValue():*
        {
            return _invocation.returnValue;
        }
        
		/** @inheritDoc */
        public function set returnValue(value:*):void
        {
            _invocation.returnValue = value;
        }
        
		/** @inheritDoc */
        public function proceed():void
        {
            _invocation.proceed();
        }
        
		/** @inheritDoc */
        public function toString():String 
        {
            return formatToString(this, "FloxyInvocation", ["invocationType", "name", "arguments"]);
        }
		
		/**
		 * @private
		 */
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