package mockolate.ingredients
{
    import flash.events.Event;
    import flash.net.URLRequest;
    
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.notNullValue;
    
    
    public class MockolatierTest
    {
        public var mockolatier:Mockolatier;
        
        [Before]
        public function createMockolatier():void
        {
            mockolatier = new Mockolatier();
        }
        
        //
        //  Prepare
        //
        
        [Test(expected="ArgumentError")]
        public function prepareWithNoClassesThrowsError():void
        {
            mockolatier.prepare();
        }
        
        [Test(expected="ArgumentError")]
        public function prepareWithInstancesThrowsError():void
        {
            mockolatier.prepare();
        }
        
        [Test(expected="ArgumentError")]
        public function prepareWithPrimitivesThrowsError():void
        {
            // TODO convert to a Theory
            mockolatier.prepare(Number);
        }
        
        [Test(expected="ArgumentError")]
        public function prepareWithFinalClassThrowsError():void
        {
            mockolatier.prepare(URLRequest);
        }
        
        [Test(async)]
        public function prepareWithClassDispatchesCompleteEvent():void
        {
            Async.proceedOnEvent(this, mockolatier, Event.COMPLETE);
            mockolatier.prepare(Flavour);
        }
        
        [Test(async)]
        public function prepareWithManyClassesDispatchesCompleteEvent():void
        {
            Async.proceedOnEvent(this, mockolatier, Event.COMPLETE);
            mockolatier.prepare(Flavour);
        }
        
        [Test(async)]
        public function prepareIgnoresAlreadyPreparedClasses():void
        {
            Async.proceedOnEvent(this, mockolatier, Event.COMPLETE);
            mockolatier.prepare(Flavour, Flavour, Flavour);
        }
        
        //
        //  Nice
        //
        
        [Test(async)]
        public function niceWithInterface():void
        {
            Async.handleEvent(this, mockolatier, Event.COMPLETE, niceWithInterface_shouldCreateInstance);
            mockolatier.prepare(Flavour);
        }
        
        private function niceWithInterface_shouldCreateInstance(event:Event):void
        {
            var flavour:Flavour = mockolatier.nice(Flavour);
            assertThat(flavour, isA(Flavour));
        }
        
        [Test(async)]
        public function niceWithClass():void
        {
            Async.handleEvent(this, mockolatier, Event.COMPLETE, niceWithClass_shouldCreateInstance);
            mockolatier.prepare(DarkChocolate);
        }
        
        public function niceWithClass_shouldCreateInstance(event:Event):void
        {
            var flavour:Flavour = mockolatier.nice(DarkChocolate);
            assertThat(flavour, isA(DarkChocolate));
        }
        
        //
        //  Strict
        //
        
        [Test(async)]
        public function strictWithInterface():void
        {
            Async.handleEvent(this, mockolatier, Event.COMPLETE, strictWithInterface_shouldCreateInstance);
            mockolatier.prepare(Flavour);
        }
        
        private function strictWithInterface_shouldCreateInstance(event:Event):void
        {
            var flavour:Flavour = mockolatier.strict(Flavour);
            assertThat(flavour, isA(Flavour));
        }
        
        [Test(async)]
        public function strictWithClass():void
        {
            Async.handleEvent(this, mockolatier, Event.COMPLETE, strictWithClass_shouldCreateInstance);
            mockolatier.prepare(DarkChocolate);
        }
        
        private function strictWithClass_shouldCreateInstance(event:Event):void
        {
            var flavour:Flavour = mockolatier.strict(DarkChocolate);
            assertThat(flavour, isA(DarkChocolate));
        }
        
        //
        //  Stubbing Nicely
        //
        
        [Test(async)]
        public function stubWithNice():void
        {
            Async.handleEvent(this, mockolatier, Event.COMPLETE, stubWithNice);
            mockolatier.prepare(Flavour);
        }
        
        private function stubWithNice_shouldCreateStubbingCouverture(event:Event):void
        {
            var flavour:Flavour = mockolatier.nice(DarkChocolate);
            mockolatier.stub(flavour, "name").returns("VeryDarkChocolate");
        }
    }
}