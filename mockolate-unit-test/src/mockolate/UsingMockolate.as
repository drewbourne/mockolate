package mockolate
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mockolate.sample.DarkChocolate;
	import mockolate.sample.Flavour;
	
	import org.flexunit.async.Async;
	import org.hamcrest.core.anything;
	
	public class UsingMockolate
	{
        [Before(async, timeout=30000)]
        public function prepareMockolates():void
        {
            Async.proceedOnEvent(this, 
                prepare(Flavour, DarkChocolate),
                Event.COMPLETE, 30000);
        }
        
        [Test]
        public function usingMockolate():void 
        {
        	var flavour:Flavour = strict(Flavour);
        	
        	// mock behaviour is always enforced
        	// mock behaviour can be verified
        	mock(flavour).method("combine").args(anything());
        	
        	// stub behaviour is never enforced
        	// stub behaviour can be verified
        	stub(flavour).property("liked").arg(true);
        	
        	// exercise mockolate
        	flavour.combine(null);
        	flavour.liked = true;
        	
        	// verify mock behaviour
        	verify(flavour);
        	
        	// verify stub behaviour as test spy
        	verify(flavour).setter("liked").arg(true);
        }
        
        [Test(expected="mockolate.mistakes.UnexpectedBehaviourError")]
        public function usingMockolateWithFailingMockBehaviour():void 
        {
        	var flavour:Flavour = strict(Flavour);
        	
        	// mock behaviour is always enforced
        	// mock behaviour can be verified
        	mock(flavour).method("combine").args(Flavour);
        	
        	// exercise mockolate with bad arguments
        	// will throw an UnexpectedBehaviourError
        	flavour.combine(null);
        }
        
        [Test(expected="mockolate.mistakes.VerifyFailedError")]
        public function usingMockolateWithFailingStubBehaviour():void 
        {
        	var flavour:Flavour = strict(Flavour);
        	
        	// stub behaviour is never enforced
        	// stub behaviour can be verified
        	stub(flavour).property("liked").arg(true);
        	
        	// exercise mockolate
        	// in this case: dont.  
        	
        	// verify stub behaviour as test spy
        	verify(flavour).setter("liked").args(true).once();
        }
	}
}