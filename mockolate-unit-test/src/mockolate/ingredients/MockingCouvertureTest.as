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
            this.mockolate = new Mockolate();
            mocker = new MockingCouverture(mockolate);
        }
        
        // method, no args, no return
        [Test(expected="mockolate.errors.ExpectationError")]
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
        
        [Test]
        public function method_once():void 
        {
        	mocker.method("example").once();
        	mocker.invoked(new FauxInvocation({ name: "example" }));
        	mocker.verify();
        }
        
        [Test]
        public function method_twice():void 
        {
        	mocker.method("example").twice();
        	mocker.invoked(new FauxInvocation({ name: "example" }));
        	mocker.verify();
        }
        
        [Test]
        public function method_thrice():void 
        {
        	mocker.method("example").twice();
        	mocker.invoked(new FauxInvocation({ name: "example" }));
        	mocker.verify();
        }
        
        [Test(expected="mockolate.errors.InvocationError")]
        public function method_never():void 
        {
        	mocker.method("example").never();
        	mocker.invoked(new FauxInvocation({ name: "example" }));
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