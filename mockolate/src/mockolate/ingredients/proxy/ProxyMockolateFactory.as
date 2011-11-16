package mockolate.ingredients.proxy
{
	import mockolate.ingredients.AbstractMockolateFactory;
	import mockolate.ingredients.MockType;
	import mockolate.ingredients.Mockolate;
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
	public class ProxyMockolateFactory extends AbstractMockolateFactory
	{
		/**
		 * Constructor. 
		 */
		public function ProxyMockolateFactory()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function create(mockType:MockType, classReference:Class, constructorArgs:Array=null, name:String=null):Mockolate 
		{
			var instance:Mockolate = new Mockolate(name);
			instance.targetClass = classReference;
			instance.mockType = mockType || MockType.NICE;
			instance.recorder = createRecorder(instance);
			instance.mocker = createMocker(instance);
			instance.verifier = createVerifier(instance);
			instance.expecter = createExpecter(instance);
			
			return instance;
		}
	}
}
