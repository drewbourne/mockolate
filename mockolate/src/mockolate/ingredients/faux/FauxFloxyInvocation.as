package mockolate.ingredients.faux
{
    import org.flemit.reflection.Type;
    import org.flemit.reflection.MethodInfo;
    import org.flemit.reflection.PropertyInfo;
    import org.floxy.IInvocation;

	/**
	 * FaxuFloxyInvocation is a NullObject implementation of IInvocation.
	 * 
	 * Used for testing.
	 * 
	 * @private
	 * @author drewbourne
	 */
    public class FauxFloxyInvocation implements IInvocation
    {
		/**
		 * Constructor. 
		 */
        public function FauxFloxyInvocation()
        {
        }

		/** @inheritDoc */
		public function get arguments():Array
        {
            return null;
        }
        
		/** @inheritDoc */
		public function get targetType():Type
        {
            return null;
        }
        
		/** @inheritDoc */
        public function get proxy():Object
        {
            return null;
        }
        
		/** @inheritDoc */
        public function get method():MethodInfo
        {
            return null;
        }
        
		/** @inheritDoc */
        public function get property():PropertyInfo
        {
            return null;
        }
        
		/** @inheritDoc */
        public function get invocationTarget():Object
        {
            return null;
        }
        
		/** @inheritDoc */
        public function get methodInvocationTarget():MethodInfo
        {
            return null;
        }
        
		/** @inheritDoc */
        public function get returnValue():Object
        {
            return null;
        }
        
		/** @inheritDoc */
        public function set returnValue(value:Object):void
        {
        }
        
		/** @inheritDoc */
        public function get canProceed():Boolean
        {
            return false;
        }
        
		/** @inheritDoc */
        public function proceed():void
        {
        }
        
    }
}