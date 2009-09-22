package mockolate.ingredients
{
    import mockolate.ingredients.faux.FauxInvocation;
    
    use namespace mockolate_ingredient;
    
    public class StubbingCouvertureTest
    {
        private var mockolate:Mockolate;
        private var stubber:StubbingCouverture;
        
        [Before]
        public function create():void
        {
            mockolate = new Mockolate();
            stubber = new StubbingCouverture(mockolate);
        }
        
        // method, no args, no return
        [Test(expected="Error")]
        public function stubMethodShouldFailIfNotInvoked():void
        {
            stubber.method("example");
            stubber.verify();
        }
        
        [Test]
        public function stubMethodShouldPassIfInvoked():void
        {
            stubber.method("example");
            stubber.invoked(new FauxInvocation({ name: "example" }));
            stubber.verify();
        }
    
        // method, args, no return
        // method, no args, return
        // method, args, return
        // method, no args, answer
        // method, args, answer
        // method, throws
        // method, calls
        // method, dispatches
        // method, times
    }
}