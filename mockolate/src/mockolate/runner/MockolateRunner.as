package mockolate.runner
{
   import asx.array.compact;
   import asx.array.pluck;
   import asx.array.unique;
   
   import flex.lang.reflect.Field;
   import flex.lang.reflect.Klass;
   import flex.lang.reflect.metadata.MetaDataAnnotation;
   
   import org.flexunit.internals.runners.InitializationError;
   import org.flexunit.internals.runners.statements.Fail;
   import org.flexunit.internals.runners.statements.IAsyncStatement;
   import org.flexunit.internals.runners.statements.RunBeforesClass;
   import org.flexunit.internals.runners.statements.StatementSequencer;
   import org.flexunit.runners.BlockFlexUnit4ClassRunner;
   import org.flexunit.runners.model.FrameworkMethod;

   public class MockolateRunner extends BlockFlexUnit4ClassRunner
   {
      private const MOCK_METADATA : String = "Mock";

      [ArrayElementType("mockolate.runner.MockMetadata")]
      private var mockMetadatas : Array;

      public function MockolateRunner (klass : Class)
      {
         super(klass);
         this.mockMetadatas = identifyMetadata(klass);
      }

      private function identifyMetadata (testClass : Class) : Array
      {
         var klass : Klass = new Klass(testClass);
         var metadatas : Array = [];

         for each (var field : Field in klass.fields)
         {
            if (field.hasMetaData(MOCK_METADATA))
            {
               try
               {
                  var metadata : MockMetadata = new MockMetadata(field.name,  field.type,  field.getMetaData(MOCK_METADATA));
                  metadatas.push(metadata);
               }
               catch (error : Error)
               {
                  throw new InitializationError(error.message);
               }
            }
         }
         
         // TODO if there are no [Mock] fields, throw an InitializationError
         // possible causes: no fields marked [Mock] or -keep-as3-metadata doesnt include Mock

         return metadatas;
      }

      protected override function withBeforeClasses () : IAsyncStatement
      {
         //build array of all class types to prepare
         var classes : Array = compact(unique(pluck(this.mockMetadatas,  "type")));

         var beforeClasses : RunBeforesClass = super.withBeforeClasses() as RunBeforesClass;

         var newBeforeClasses : StatementSequencer = new StatementSequencer();
         newBeforeClasses.addStep(new Prepare(classes));
         newBeforeClasses.addStep(beforeClasses);

         return newBeforeClasses;
      }

      protected override function methodBlock (method : FrameworkMethod) : IAsyncStatement
      {
         //COPY/PASTE FROM PARENT to supplement runner until refactor
         var c : Class;

         var test : Object;
         
         //might need to be reflective at some point
         try
         {
            test = createTest();
         }
         catch (e : Error)
         {
            trace(e.getStackTrace());
            return new Fail(e);
         }

         var sequencer : StatementSequencer = new StatementSequencer();

         //inject mocks before all befores executes
         sequencer.addStep(new Inject(mockMetadatas, test));

         sequencer.addStep(withBefores(method,  test));
         sequencer.addStep(withDecoration(method,  test));
         sequencer.addStep(withAfters(method,  test));

         //verify mocks after all afters executes
         var propertiesToVerify : Array = pluck(this.mockMetadatas,  "name");
         sequencer.addStep(new Verify(method, propertiesToVerify, test));

         return sequencer;
      }
   }
}