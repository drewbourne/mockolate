package mockolate.runner
{
	import mockolate.ingredients.ClassRecipes;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.Mockolatier;
	
	import org.flexunit.runners.model.FrameworkMethod;
	import mockolate.ingredients.InstanceRecipes;

	/**
	 * ValueObject for data used by the MockolateRunner and MockolateRule. 
	 * 
	 * @author drewbourne
	 */	
	public class MockolateRunnerData
	{
		/** 
		 * Mockolatier to use to prepare, instantiate and verify instances. 
		 */
		public var mockolatier:Mockolatier; 
		
		/**
		 * Instance of the Testcase Class currently being run.
		 */		
		public var test:Object;
		
		/**
		 * Reference to the FrameworkMethod for the current [Test]
		 */		
		public var method:FrameworkMethod;
		
		/**
		 * ClassRecipe for Class to prepare for the test. 
		 */		
		public var classRecipes:ClassRecipes;
		
		/**
		 * InstanceRecipes for instances to prepare for the test. 
		 */
		public var instanceRecipes:InstanceRecipes;
	}
}