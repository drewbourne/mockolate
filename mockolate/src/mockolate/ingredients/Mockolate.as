package mockolate.ingredients
{
    use namespace mockolate_ingredient;
    
    /**
     *
     */
    public class Mockolate
    {
        private var _recorder:RecordingCouverture;
        private var _stubber:StubbingCouverture;
        private var _verifier:VerifyingCouverture;
        
        // flags
        private var _isStrict:Boolean;
        
        // target!
        private var _target:*;
        private var _targetClass:Class;
        
        // identifier
        private var _name:String;
        
        /**
         *
         */
        public function Mockolate(name:String=null)
        {
            super();
            
            _name = name;
        }
        
        public function get name():String
        {
            return _name;
        }
        
        /**
         *
         */
        mockolate_ingredient function get recorder():RecordingCouverture
        {
            return _recorder;
        }
        
        mockolate_ingredient function set recorder(value:RecordingCouverture):void
        {
            _recorder = value;
        }
        
        /**
         *
         */
        mockolate_ingredient function get stubber():StubbingCouverture
        {
            return _stubber;
        }
        
        mockolate_ingredient function set stubber(value:StubbingCouverture):void
        {
            _stubber = value;
        }
        
        /**
         *
         */
        mockolate_ingredient function get verifier():VerifyingCouverture
        {
            return _verifier;
        }
        
        mockolate_ingredient function set verifier(value:VerifyingCouverture):void
        {
            _verifier = value;
        }
        
        /**
         *
         */
        mockolate_ingredient function get isStrict():Boolean
        {
            return _isStrict;
        }
        
        mockolate_ingredient function set isStrict(value:Boolean):void
        {
            _isStrict = value;
        }
        
        /**
         *
         */
        mockolate_ingredient function get target():*
        {
            return _target;
        }
        
        mockolate_ingredient function set target(value:*):void
        {
            if (_target)
            {
                throw new ArgumentError("This Mockolate already has a target, received:" + value);
            }
            
            _target = value;
        }
        
        /**
         *
         */
        mockolate_ingredient function invoked(invocation:Invocation):void
        {
            // these are specifically this order
            // so that the recording couvertures are invoked
            // prior to any exception possibly being thrown by the stubber
            // 
            // this will probably change to a safer and DRYer mechanism shortly
            
            if (_recorder)
                _recorder.invoked(invocation);
            
            if (_verifier)
                _verifier.invoked(invocation);
            
            if (_stubber)
                _stubber.invoked(invocation);
        }
    }
}
