package mockolate.runner
{
   import asx.array.contains;
   import asx.string.substitute;
   
   import flex.lang.reflect.Klass;
   import flex.lang.reflect.metadata.MetaDataAnnotation;
   import flex.lang.reflect.metadata.MetaDataArgument;

   public class MockMetadata
   {
      private const MOCK_TYPE_ARGUMENT : String = "type";
      private const INJECT_ARGUMENT : String = "inject";
      
      public var name : String;
      public var type : Class;
      public var mockType : String;
      public var injectable : Boolean;

      public function MockMetadata (name : String,  type : Class,  metadata : MetaDataAnnotation)
      {
         this.name = name;
         this.type = type;
         this.mockType = parseMockType(metadata.getArgument(MOCK_TYPE_ARGUMENT));
         this.injectable = parseInject(metadata.getArgument(INJECT_ARGUMENT));
      }

      private function parseMockType (argument : MetaDataArgument) : String
      {
         const NICE : String = "nice";
         const STRICT : String = "strict";
         
         //default value
         var type : String = NICE;

         if (argument)
         {
            type = argument.value;

            //possible string values
            if (!contains([NICE,  STRICT],  type))
            {
               var message : String = substitute("Property '{}' must declare a mock type of either 'nice' or 'strict'; '{}' is NOT a valid type.",  this.name,  type);
               throw new Error(message);
            }
         }

         return type;
      }

      private function parseInject (argument : MetaDataArgument) : Boolean
      {
         const TRUE : String = "true";
         const FALSE : String = "false";
         
         //default value
         var injectable : Boolean = true;

         if (argument)
         {
            var injectableValue : String = argument.value;

            //possible string values
            if (!contains([TRUE,  FALSE],  injectableValue))
            {
               throw new Error(substitute("Property '{}' must declare the attribute inject as either 'true' or 'false'; '{}' is NOT valid.",  this.name,  injectable));
            }

            injectable = injectableValue == TRUE;

            if (injectable)
            {
               var constructorParamLength : Number = new Klass(this.type).constructor.parameterTypes.length;
               
               //can mock be injected?
               if (constructorParamLength != 0)
               {
                  throw new Error(substitute("Cannot inject mock of type '{}' into property '{}'; constructor arguments are required!	 Please set inject='false' and manually create the mock in the [Before] for this test class.",  this.type,  this.name));
               }
            }
         }

         return injectable;
      }
   }
}