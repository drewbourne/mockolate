package mockolate.ingredients.proxy
{
	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;
	
	import mockolate.ingredients.AbstractMockolateFactory;
	import mockolate.ingredients.ExpectingCouverture;
	import mockolate.ingredients.IMockolateFactory;
	import mockolate.ingredients.MockType;
	import mockolate.ingredients.MockingCouverture;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.RecordingCouverture;
	import mockolate.ingredients.VerifyingCouverture;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace mockolate_ingredient;

	/**
	 * ProxyMockolateFactory creates Mockolate instances for use with MockolateProxy.
	 * 
	 * @see MockolateProxy
	 * 
	 * @private
	 * @author drewbourne
	 */
	public class ProxyMockolateFactory extends AbstractMockolateFactory implements IMockolateFactory
	{
		/**
		 * Constructor. 
		 */
		public function ProxyMockolateFactory()
		{
			super();
		}
		
		/**
		 * ProxyMockolateFactory does not need to prepare classes.
		 * @private 
		 */
		public function prepare(...classes):IEventDispatcher
		{
			throw new IllegalOperationError("ProxyMockolateFactory.prepare() is not needed, use create() only.");
		}
		
		/**
		 * @inheritDoc
		 */
		public function create(mockType:MockType, classReference:Class, constructorArgs:Array=null, name:String=null):Mockolate 
		{
			var instance:Mockolate = new Mockolate(name);
			instance.targetClass = classReference;
			instance.mockType = mockType || MockType.STRICT;
			instance.recorder = createRecorder(instance);
			instance.mocker = createMocker(instance);
			instance.verifier = createVerifier(instance);
			instance.expecter = createExpecter(instance);
			
			return instance;
		}
	}
}
