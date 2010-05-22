package mockolate.runner
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import mockolate.prepare;
   
   import org.flexunit.internals.runners.InitializationError;
   import org.flexunit.internals.runners.statements.IAsyncStatement;
   import org.flexunit.token.AsyncTestToken;
   
   [ExcludeClass]

   public class Prepare implements IAsyncStatement
   {
      public static const TIMEOUT : Number = 5000;

      [ArrayElementType("Class")]
      private var classes : Array;

      public function Prepare (classes : Array)
      {
         this.classes = classes;
      }

      public function evaluate (parentToken : AsyncTestToken) : void
      {
         if(classes.length == 0)
         {
            parentToken.sendResult(null);
            return;
         }

         var timer : Timer = new Timer(TIMEOUT);
         timer.addEventListener(TimerEvent.TIMER,  function (event : Event = null) : void
            {
               timer.stop();
               parentToken.sendResult(new InitializationError("Mock preparation timeout of " + TIMEOUT + "exceeded!"));
            });

         var responder : IEventDispatcher = prepare(classes);

         responder.addEventListener(Event.COMPLETE,  function (event : Event) : void
            {
               timer.stop()
               parentToken.sendResult(null);
            });
      }
   }
}