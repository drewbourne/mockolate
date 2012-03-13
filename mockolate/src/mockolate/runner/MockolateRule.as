package mockolate.runner
{
	import flash.events.IEventDispatcher;
	
	import mockolate.ingredients.ExpectingCouverture;
	import mockolate.ingredients.InstanceRecipe;
	import mockolate.ingredients.MockType;
	import mockolate.ingredients.MockingCouverture;
	import mockolate.ingredients.Mockolatier;
	import mockolate.ingredients.MockolatierMaster;
	import mockolate.ingredients.Spy;
	import mockolate.ingredients.VerifyingCouverture;
	import mockolate.ingredients.anInstanceRecipe;
	import mockolate.ingredients.mockolate_ingredient;
	import mockolate.runner.statements.IdentifyMockClasses;
	import mockolate.runner.statements.InjectMockInstances;
	import mockolate.runner.statements.PrepareMockClasses;
	import mockolate.runner.statements.VerifyMockInstances;
	
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.MethodRuleBase;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.rules.IMethodRule;
	import org.flexunit.runners.model.FrameworkMethod;
	import org.flexunit.token.AsyncTestToken;
	
	use namespace mockolate_ingredient;
	
	/**
	 * MockolateRule is the recommended way to enable Mockolate support in
	 * testcases using FlexUnit 4.1 and up. 
	 * 
	 * Use [Mock] metadata to mark public vars that should be injected with a
	 * Mockolate instance.
	 * 
	 * @example
	 * <listing version="3.0">
	 *	public class UsingMockolateRuleExample 
	 * 	{
	 * 		[Rule]
	 * 		public var mockolateRule:MockolateRule = new MockolateRule();
	 * 
	 * 		[Mock]
	 * 		public var flavour:Flavour;
	 * 
	 * 		[Before]
	 * 		public function setup():void 
	 * 		{
	 * 			// flavour variable is populated with a Flavour instance
	 * 		}
	 * 
	 * 		[Test]
	 * 		public function example():void 
	 * 		{
	 * 			// perform test using flavour
	 * 		} 
	 * 	} 
	 * </listing>
	 * 
	 * @author drewbourne
	 */
	public class MockolateRule extends MethodRuleBase implements IMethodRule
	{
		/** @private */
		mockolate_ingredient var mockolatier:Mockolatier;
		
		protected var sequence:StatementSequencer;
		protected var data:MockolateRunnerData;
		
		/**
		 * Constructor. 
		 */
		public function MockolateRule()
		{
			super();
			
			mockolatier = MockolatierMaster.mockolatier;
		}
		
		/**
		 * @copy mockolate#prepare()
		 */
		public function prepare(...rest):IEventDispatcher
		{
			return mockolatier.prepare.apply(null, rest);
		}
		
		/**
		 * Creates a new 'nice' Mockolate and adds it to the Mockolates that will
		 * be verified by the MockolateRule.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	public class ExtraMocks {
		 * 		[Rule]
		 * 		public var mocks:MockolateRule = new MockolateRule();
		 * 
		 * 		[Mock]
		 * 		public var flavour1:Flavour;
		 * 
		 * 		[Test]
		 * 		public function moreFlavours():void {
		 * 			var flavour2:Flavour = mocks.nice(Flavour);
		 * 			// mock() stub() f2 and it will be verified for you. 
		 * 		} 
		 * 	}
		 * </listing>
		 */
		public function nice(classReference:Class, name:String=null, constructorArgs:Array=null):*
		{
			return prepareInstance(createInstanceRecipeFor(MockType.NICE, classReference, name, constructorArgs));
		}
		
		/**
		 * Creates a new 'strict' Mockolate and adds it to the Mockolates that will
		 * be verified by the MockolateRule.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	public class ExtraMocks {
		 * 		[Rule]
		 * 		public var mocks:MockolateRule = new MockolateRule();
		 * 
		 * 		[Mock]
		 * 		public var flavour1:Flavour;
		 * 
		 * 		[Test]
		 * 		public function moreFlavours():void {
		 * 			var flavour2:Flavour = mocks.strict(Flavour);
		 * 			// mock() stub() flavour2 and it will be verified for you. 
		 * 		} 
		 * 	}
		 * </listing>
		 */
		public function strict(classReference:Class, name:String=null, constructorArgs:Array=null):* 
		{
			return prepareInstance(createInstanceRecipeFor(MockType.STRICT, classReference, name, constructorArgs));
		}
		
		/**
		 * @copy mockolate#partial()
		 */
		public function partial(classReference:Class, name:String=null, constructorArgs:Array=null):*
		{
			return prepareInstance(createInstanceRecipeFor(MockType.PARTIAL, classReference, name, constructorArgs));
		}
		
		private function createInstanceRecipeFor(
			type:MockType, classReference:Class, name:String=null, constructorArgs:Array=null):InstanceRecipe
		{
			return mockolatier.createInstanceRecipeFor(type, classReference, name, constructorArgs);	
		}
		
		private function prepareInstance(instanceRecipe:InstanceRecipe):*
		{
			data.instanceRecipes.add(instanceRecipe);
			
			return mockolatier.prepareInstance(instanceRecipe);
		}
		
		/**
		 * @copy mockolate#mock()
		 */
		public function mock(target:*):MockingCouverture
		{
			return mockolatier.mock(target);
		}
		
		/**
		 * @copy mockolate#stub()
		 */
		public function stub(target:*):MockingCouverture
		{
			return mockolatier.stub(target);
		}
		
		/**
		 * @copy mockolate#verify()
		 */
		public function verify(target:*):VerifyingCouverture
		{
			return mockolatier.verify(target);
		}
		
		[Deprecated]
		/**
		 * @copy mockolate#record()
		 */
		public function record(target:*):*
		{
		}
		
		[Deprecated]
		/**
		 * @copy mockolate#replay()
		 */
		public function replay(target:*):*
		{
		}
		
		/**
		 * @copy mockolate#allow()
		 */
		public function allow(target:*):ExpectingCouverture
		{
			return mockolatier.allow(target);
		}		
		
		/**
		 * @copy mockolate#expect()
		 */
		public function expect(target:*):ExpectingCouverture
		{
			return mockolatier.expect(target);
		}

		/**
		 * @copy mockolate#arg()
		 */
		public function arg(value:*):*
		{
			return mockolatier.expectArg(value);
		}
		
		[Deprecated(replacement="#arg")]
		/**
		 * @copy mockolate#expectArg()
		 */
		public function expectArg(value:*):*
		{
			return mockolatier.expectArg(value);
		}
		
		/**
		 * @copy mockolate#expecting()
		 */
		public function expecting(context:Function):void
		{
			return mockolatier.expecting(context);
		}

		/**
		 *
		 */
		public function spy(target:*):Spy 
		{
			return mockolatier.spy(target);
		}
		
		//
		//	IMethodRule
		//
		
		/**
		 * @private
		 */
		override public function apply(base:IAsyncStatement, method:FrameworkMethod, test:Object):IAsyncStatement
		{
			super.apply(base, method, test);
			
			this.data = new MockolateRunnerData();
			this.data.mockolatier = mockolatier;
			this.data.test = test;
			this.data.method = method;
			
			sequence = new StatementSequencer();
			sequence.addStep(new IdentifyMockClasses(data));
			sequence.addStep(new PrepareMockClasses(data));
			sequence.addStep(new InjectMockInstances(data));
			sequence.addStep(base);
			sequence.addStep(new VerifyMockInstances(data));
						
			return this;
		}
		
		/**
		 * @private
		 */
		override public function evaluate(parentToken:AsyncTestToken):void 
		{
			super.evaluate(parentToken);
			
			sequence.evaluate(myToken);
		}
		
		/**
		 * @private
		 */
		override public function toString():String
		{
			return "MockolateRule";
		}
	}
}
