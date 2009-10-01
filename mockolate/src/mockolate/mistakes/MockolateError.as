package mockolate.errors
{
    import mockolate.ingredients.Mockolate;
    
    public class MockolateError extends Error
    {
        private var _mockolate:Mockolate;
        private var _target:Object;
        
        public function MockolateError(message:String, mockolate:Mockolate, target:Object)
        {
            super(message);
            
            _mockolate = mockolate;
            _target = target;
        }
        
        public function get mockolate():Mockolate
        {
            return _mockolate;
        }
        
        public function get target():Object
        {
            return _target;
        }
    }
}
