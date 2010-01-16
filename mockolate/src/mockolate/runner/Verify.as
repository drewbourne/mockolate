package mockolate.runner
{
   import asx.array.compact;
   
   import mockolate.errors.MockolateError;
   import mockolate.verify;
   
   import org.flexunit.internals.runners.statements.IAsyncStatement;
   import org.flexunit.token.AsyncTestToken;

   public class Verify implements IAsyncStatement
   {
      private var verifyMethod : Boolean;

      [ArrayElementType("String")]
      private var properties : Array;

      private var target : Object;

      public function Verify (metadataValue : String,  names : Array,  target : Object)
      {
         this.properties = names;
         this.verifyMethod = parseVerifyMetadata(metadataValue);
      }

      private function parseVerifyMetadata (value : String) : Boolean
      {
         return!value || value == "true";
      }

      public function evaluate (parentToken : AsyncTestToken) : void
      {
         if(verifyMethod)
         {
            //iterate over all properties and call verify
            var mocksToVerify : Array = compact(properties.map(function (property : String,  index : int,  source : Array) : Object
               {
                  return target[property];
               }));

            try
            {
               verify(mocksToVerify);
            }
            catch(error : MockolateError)
            {
               //if error is thrown catch it and pass it onto the parentToken
               parentToken.sendResult(error);
               return;
            }
         }

         parentToken.sendResult(null);
      }
   }
}