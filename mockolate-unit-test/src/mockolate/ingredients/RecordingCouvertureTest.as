package mockolate.ingredients
{
    import mockolate.ingredients.faux.FauxInvocation;
    
    import org.flexunit.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.object.sameInstance;
    
    use namespace mockolate_ingredient;
    
    public class RecordingCouvertureTest
    {
        private var mockolate:Mockolate;
        private var couverture:RecordingCouverture;
        private var invocation1:Invocation;
        private var invocation2:Invocation;
        private var invocation3:Invocation;
        
        [Before]
        public function create():void
        {
            mockolate = new Mockolate();
            couverture = new RecordingCouverture(mockolate);
            // FIXME dogfood it, replace with mock Invocation instances
            invocation1 = new FauxInvocation();
            invocation2 = new FauxInvocation()
            invocation3 = new FauxInvocation()
        }
        
        [Test]
        public function whenInvokedShouldHaveRecordedInvocation():void
        {
            couverture.invoked(invocation1);
            assertThat(couverture.invocations, array(sameInstance(invocation1)));
            
            couverture.invoked(invocation2);
            couverture.invoked(invocation3);
            assertThat(couverture.invocations, array(
                sameInstance(invocation1),
                sameInstance(invocation2),
                sameInstance(invocation3)));
        }
    }
}
