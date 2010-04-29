package mockolate.ingredients.proxy
{
	import flash.errors.IllegalOperationError;
	import flash.events.IEventDispatcher;
	
	import mockolate.ingredients.MockingCouverture;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.MockolateFactory;
	import mockolate.ingredients.VerifyingCouverture;
	import mockolate.ingredients.mockolate_ingredient;
	
	use namespace mockolate_ingredient;

	public class ProxyMockolateFactory implements MockolateFactory
	{
		public function ProxyMockolateFactory()
		{
			super();
		}
		
		public function prepare(...rest):IEventDispatcher
		{
			throw new IllegalOperationError("ProxyMockolateFactory.prepare() is not needed, use create() only.");
		}
		
		public function create(classReference:Class, constructorArgs:Array=null, asStrict:Boolean=true, name:String=null):Mockolate 
		{
			var mockolate:Mockolate = new Mockolate(name);
			mockolate.targetClass = classReference;
			mockolate.isStrict = asStrict;		
			mockolate.mocker = createMocker(mockolate);
			mockolate.verifier = createVerifier(mockolate);
			
			return mockolate;
		}
		
		/**
		 * @private 
		 */
		protected function createMocker(mockolate:Mockolate):MockingCouverture
		{
			return new MockingCouverture(mockolate);
		}
		
		/**
		 * @private 
		 */
		protected function createVerifier(mockolate:Mockolate):VerifyingCouverture
		{
			return new VerifyingCouverture(mockolate);
		}
	}
}
