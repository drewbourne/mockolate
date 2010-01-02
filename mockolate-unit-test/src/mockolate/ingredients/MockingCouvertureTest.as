package mockolate.ingredients
{
    import mockolate.ingredients.faux.FauxInvocation;
    
    use namespace mockolate_ingredient;
    
    public class MockingCouvertureTest
    {
        private var mockolate:Mockolate;
        private var mocker:MockingCouverture;
        
        [Before]
        public function create():void
        {
            mockolate = new Mockolate();
            mocker = new MockingCouverture(mockolate);
        }
        
        // method, no args, no return
        [Test(expected="Error")]
        public function mockMethodShouldFailIfNotInvoked():void
        {
            mocker.method("example");
            mocker.verify();
        }
        
        [Test]
        public function mockMethodShouldPassIfInvoked():void
        {
            mocker.method("example");
            mocker.invoked(new FauxInvocation({ name: "example" }));
            mocker.verify();
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