package mockolate.runner
{
   import mockolate.nice;
   import mockolate.strict;
   
   import org.flexunit.internals.runners.statements.IAsyncStatement;
   import org.flexunit.token.AsyncTestToken;
   
   [ExcludeClass]

   public class Inject implements IAsyncStatement
   {
      [ArrayElementType("mockolate.runner.MockMetadata")]
      private var metadatas : Array;
      
      private var target : Object;

      public function Inject (metadatas : Array, target : Object)
      {
         this.metadatas = metadatas;
         this.target = target;
      }

      public function evaluate (parentToken : AsyncTestToken) : void
      {
         //find properties on target, inject using nice/strict and casting as klass
         for each(var metadata : MockMetadata in metadatas)
         {
            if(metadata.injectable)
            {
               var klass : Class = metadata.type;
               var mock : Object = metadata.mockType == "strict" ? strict(klass) : nice(klass);
               target[metadata.name] = mock as klass;
            }
         }

         parentToken.sendResult(null);
      }
   }
}