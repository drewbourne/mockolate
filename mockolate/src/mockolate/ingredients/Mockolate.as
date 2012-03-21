package mockolate.ingredients
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.hamcrest.Description;
	import org.hamcrest.StringDescription;
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
		private var _spies:Array;
		
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
			_mockType = MockType.STRICT;
			_spies = [];
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

		/**
		 * Used to indicate the behaviour of a Mockolate instance when an Expectation
		 * is not defined for an Invocation.
		 * 
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
			_recorder.addInvocation(invocation);

			try
			{
				var handled:Boolean = _mocker.invoked(invocation);
				
				if (!handled)
				{
					_recorder.addUnexpectedInvocation(invocation);
				}
			}
			catch (error:Error)
			{
				invocation.error = error;

				throw error;
			}
			finally
			{
				for each (var spy:Spy in _spies)
				{
					spy.invoked(invocation);
				}
			}

			return this;
		}
		
		/**
		 * Called when <code>verify(instance)</code> is called. 
		 */
		public function verify():Mockolate
		{
			if (_verifier)
				_verifier.verify();

			if (_mocker)
				_mocker.verify();
				
			return this;
		}

		/**
		 * Define an optional Expectation.
		 */
		public function allow(invocation:Invocation, args:Array):ExpectingCouverture
		{
			return _expecter.allow(invocation, args);
		}

		/**
		 * Define a required Expectation.
		 */
		public function expect(invocation:Invocation, args:Array):ExpectingCouverture
		{
			return _expecter.expect(invocation, args);
		}

		/**
		 * Create a Spy for this Mockolate instance from the given Invocation and Arguments.
		 */
		public function spy(invocation:Invocation, args:Array):Spy 
		{
			var spy:Spy = new Spy(this, invocation, args);

			_spies.push(spy);

			return spy;
		}

		/**
		 * Describes this Mockolate to the given Description.
		 */
		public function describeTo(description:Description):void 
		{
			var qname:String = getQualifiedClassName(targetClass);
			
			description.appendText(qname);
			
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
