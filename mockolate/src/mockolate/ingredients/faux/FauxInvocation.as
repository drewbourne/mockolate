package mockolate.ingredients.faux
{
    import asx.string.formatToString;
    
    import flash.errors.IllegalOperationError;
    
    import mockolate.ingredients.AbstractInvocation;
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.InvocationType;
    
    import org.hamcrest.Description;
    
	/**
	 * FauxInvocation provides an Invocation implementation for use in testing.
	 * 
	 * @author drewbourne
	 */
    public class FauxInvocation extends AbstractInvocation implements Invocation
    {
        private var _options:Object;
        
		/**
		 * Constructor.
		 *  
		 * @param options Object of key-values to return from the properties of 
		 * 				  this Invocation.
		 */
        public function FauxInvocation(options:Object=null)
        {
            _options = options || {};
        }
        
		/** @inheritDoc */
        public function get target():Object
        {
            return _options.target;
        }
        
		/** @inheritDoc */
        public function get name():String
        {
            return _options.name;
        }
        
		/** @inheritDoc */
        public function get invocationType():InvocationType
        {
            return _options.invocationType || InvocationType.METHOD;
        }
        
		/** @inheritDoc */
        public function get isMethod():Boolean
        {
            return invocationType == InvocationType.METHOD;
        }
        
		/** @inheritDoc */
        public function get isGetter():Boolean
        {
            return invocationType == InvocationType.GETTER;
        }
        
		/** @inheritDoc */
        public function get isSetter():Boolean
        {
            return invocationType == InvocationType.SETTER;
        }
        
		/** @inheritDoc */
        public function get arguments():Array
        {
            return _options.arguments;
        }
        
		/** @inheritDoc */
        public function get returnValue():*
        {
            return _options.returnValue;
        }
        
		/** @inheritDoc */
        public function set returnValue(value:*):void
        {
            _options.returnValue = value;
        }
        
		/** @inheritDoc */
        public function proceed():void
        {
            if (!target)
			{
				return;
			}
			
            if (isMethod)
            {
                target[name].apply(target, this.arguments || []);
            }
            else if (isGetter)
            {
                returnValue = target[name];
            }
            else if (isSetter)
            {
                target[name] = arguments ? arguments[0] : null;
            }
        }
        
		/** @inheritDoc */
        public function toString():String 
        {
            return formatToString(this, "FauxInvocation", ["invocationType", "name", "arguments"]);
        }
		
//		/**
//		 * Describes the FauxInvocation to the Description. 
//		 */
//		public function describeTo(description:Description):void 
//		{
//			description.appendText(toString());
//		}
    }
}
