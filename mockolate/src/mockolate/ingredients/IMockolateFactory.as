package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    /**
     * Factory interface to prepare and create Mockolate instances.
     * 
     * @author drewbourne
     */
    public interface IMockolateFactory
    {
		function prepareClasses(classRecipes:ClassRecipes):IEventDispatcher;
		
		function prepareInstances(instanceRecipes:InstanceRecipes):IEventDispatcher;
		
		function prepareInstance(instanceRecipe:InstanceRecipe):InstanceRecipe;
   }
}