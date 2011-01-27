package mockolate.ingredients
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.hamcrest.Description;
	import org.hamcrest.SelfDescribing;
	
    use namespace mockolate_ingredient;
    
    /**
     * Each Mockolate instances manages the mocking, stubbing, spying and 
     * verifying behaviour of an individual instance prepared and created by 
     * the Mockolate library.
     * 
     * @author drewbourne
     */
    public class Mockolate implements SelfDescribing
    {
		private var _recorder:RecordingCouverture;
        private var _mocker:MockingCouverture;
        private var _verifier:VerifyingCouverture;
		private var _expecter:ExpectingCouverture;
        
        // flags
        private var _isStrict:Boolean;
		private var _isRecording:Boolean;
        
        // target!
        private var _target:*;
        private var _targetClass:Class;
        
        private var _name:String;
		private var _mockType:MockType;
		
        /**
         * Constructor.
         */
        public function Mockolate(name:String=null)
        {
            super();
            
            _name = name;
            _isStrict = true;
			_mockType = MockType.STRICT;
        }
        
        /**
         * Name of this Mockolate. 
         */
        public function get name():String
        {
            return _name;
        }
		
		/**
		 * RecordingCouverture instance of this Mockolate. 
		 */
		mockolate_ingredient function get recorder():RecordingCouverture
		{
			return _recorder;
		}
		
		/** @private */
		mockolate_ingredient function set recorder(value:RecordingCouverture):void
		{
			_recorder = value;
		}

        /**
         * MockingCouverture instance of this Mockolate. 
         */
        mockolate_ingredient function get mocker():MockingCouverture
        {
            return _mocker;
        }
        
        /** @private */
        mockolate_ingredient function set mocker(value:MockingCouverture):void
        {
            _mocker = value;
        }
        
        /**
         * VerifyingCouverture instance of this Mockolate.
         */
        mockolate_ingredient function get verifier():VerifyingCouverture
        {
            return _verifier;
        }
        
        /** @private */
        mockolate_ingredient function set verifier(value:VerifyingCouverture):void
        {
            _verifier = value;
        }
		
		/**
		 * ExpectingCouverture instance of this Mockolate.
		 */
		mockolate_ingredient function get expecter():ExpectingCouverture
		{
			return _expecter;
		}
		
		/** @private */
		mockolate_ingredient function set expecter(value:ExpectingCouverture):void
		{
			_expecter = value;
		}
        
		[Deprecated]
        /**
         * Indicates if this Mockolate is in strict mode. 
         * 
         * Given <code>isStrict</code> is <code>true</code>
         * when a method or property is invoked that does not have a 
         * <code>mock()</code> or <code>stub()</code> expectation set
         * then an ExpectationError will be thrown.
         * 
         * Given <code>isStrict</code> is <code>false</code>
         * when a method or property is invoked that does not have a
         * <code>mock()</code> or <code>stub()</code> expectation set
         * then an appropriate false-y value will be returned.
         *  
         * Eg: <code>false, NaN, 0, null, undefined</code>. 
         */
        mockolate_ingredient function get isStrict():Boolean
        {
            return _isStrict;
        }
        
        /** @private */
        mockolate_ingredient function set isStrict(value:Boolean):void
        {
            _isStrict = value;
        }
		
		/**
		 * @see MockType
		 */
		mockolate_ingredient function get mockType():MockType
		{
			return _mockType;
		}
		
		/** @private */
		mockolate_ingredient function set mockType(value:MockType):void
		{
			_mockType = value;
		}
        
        /**
         * Reference to the instance this Mockolate is managing.
         */
        mockolate_ingredient function get target():*
        {
            return _target;
        }
        
        /** @private */
        mockolate_ingredient function set target(value:*):void
        {
            if (_target)
            {
                throw new ArgumentError("This Mockolate already has a target, received:" + value);
            }
            
            _target = value;            
        }
        
        /**
         * Reference to the instance this Mockolate is managing.
         */
        mockolate_ingredient function get targetClass():*
        {
            return _targetClass;
        }
        
        /** @private */
        mockolate_ingredient function set targetClass(value:*):void
        {
            if (_targetClass)
            {
                throw new ArgumentError("This Mockolate already has a targetClass, received:" + value);
            }
            
            _targetClass = value;            
        }
        
        /**
         * Called when a method or property is invoked on the target instance. 
         */
        mockolate_ingredient function invoked(invocation:Invocation):Mockolate
        {
            // these are specifically this order
            // so that the recording couvertures are invoked
            // prior to any exception possibly being thrown by the mocker
                        
			if (_isRecording)
			{
				if (_expecter)
					_expecter.invoked(invocation);
			}
			else
			{
				if (_recorder)
					_recorder.invoked(invocation);
				
	            if (_verifier)
	                _verifier.invoked(invocation);
	
	            if (_mocker)
	                _mocker.invoked(invocation);            
			}

			return this;
        }
        
        /**
         * Called when <code>verify(instance)</code> is called. 
         */
        mockolate_ingredient function verify():Mockolate
        {
            if (_verifier)
                _verifier.verify();

            if (_mocker)
                _mocker.verify();
            	
			return this;
        }
		
		/**
		 * Indicates if this Mockolate is currently set to record expectations. 
		 */
		mockolate_ingredient function isRecording():Boolean
		{
			return _isRecording;
		}
		
		/**
		 * Sets this Mockolate to record expectations from invocations.
		 */
		mockolate_ingredient function record():Mockolate
		{
			_isRecording = true;
			return this;
		}
		
		/**
		 * Sets this Mockolate to stop recording and start replaying expectations.
		 */
		mockolate_ingredient function replay():Mockolate
		{
			_isRecording = false;
			return this;
		}
		
		/**
		 * Describes this Mockolate to the given Description.
		 */
		public function describeTo(description:Description):void 
		{
			var qname:String = getQualifiedClassName(targetClass);
			
			description.appendText(qname.slice(qname.lastIndexOf('::') + 2));
			
			if (name)
			{
				description
					.appendText("(")
					.appendText(name)
					.appendText(")");
			}
		}
    }
}
