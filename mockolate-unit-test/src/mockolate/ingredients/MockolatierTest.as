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
        	var event:Event = new Event("test");
            mockolatier.prepare(event);
        }
        
        [Ignore(description="as the VerifyError is async we cannot catch it.")]
        [Test(async, expected="VerifyError")]
        public function prepareWithPrimitivesThrowsError():void
        { 
            mockolatier.prepare(Number);
        }
        
        [Ignore(description="as the VerifyError is async we cannot catch it.")]
        [Test(async, expected="VerifyError")]
        public function prepareWithFinalClassThrowsError():void
        {
			mockolatier.prepare(URLRequest);
        }
        
        [Test(async, timeout=5000)]
        public function prepareWithClassDispatchesCompleteEvent():void
        {
            Async.proceedOnEvent(this, 
            	mockolatier.prepare(Flavour), 
				Event.COMPLETE);
        }
        
        [Test(async, timeout=5000)]
        public function prepareWithManyClassesDispatchesCompleteEvent():void
        {
            Async.proceedOnEvent(this, 
				mockolatier.prepare(Flavour, DarkChocolate), 
				Event.COMPLETE);
        }
        
        [Test(async, timeout=5000)]
        public function prepareIgnoresAlreadyPreparedClasses():void
        {
            Async.proceedOnEvent(this, 
				mockolatier.prepare(Flavour, Flavour, Flavour), 
				Event.COMPLETE);
        }
		
		//
		// 	prepareClassRecipes()
		//
        
        //
        //  Nice
        //
        
        [Test(async, timeout=5000)]
        public function niceWithInterface():void
        {
            Async.handleEvent(this, 
				mockolatier.prepare(Flavour), 
				Event.COMPLETE, 
				niceWithInterface_shouldCreateInstance(mockolatier), 5000);
        }
        
        private function niceWithInterface_shouldCreateInstance(mockolate:Mockolatier):Function
		{
			return function (event:Event, data:Object=null):void 
			{
				var flavour:Flavour = mockolatier.nice(Flavour);
            	assertThat(flavour, isA(Flavour));
			}
        }
        
        [Test(async, timeout=5000)]
        public function niceWithClass():void
        {
            Async.handleEvent(this, 
				mockolatier.prepare(DarkChocolate), 
				Event.COMPLETE, 
				niceWithClass_shouldCreateInstance(mockolatier), 5000);
        }
        
        public function niceWithClass_shouldCreateInstance(mockolate:Mockolatier):Function
		{
			return function (event:Event, data:Object=null):void 
			{
				var flavour:Flavour = mockolatier.nice(DarkChocolate);
            	assertThat(flavour, isA(DarkChocolate));
			}
        }
        
        //
        //  Strict
        //
        
        [Test(async, timeout=5000)]
        public function strictWithInterface():void
        {
            Async.handleEvent(this, 
				mockolatier.prepare(Flavour), 
				Event.COMPLETE, 
				strictWithInterface_shouldCreateInstance(mockolatier), 5000);
        }
        
        private function strictWithInterface_shouldCreateInstance(mockolate:Mockolatier):Function
		{
			return function (event:Event, data:Object=null):void 
			{
				var flavour:Flavour = mockolatier.strict(Flavour);
            	assertThat(flavour, isA(Flavour));
			}
        }
        
        [Test(async, timeout=5000)]
        public function strictWithClass():void
        {
            Async.handleEvent(this, 
				mockolatier.prepare(DarkChocolate), 
				Event.COMPLETE, 
				strictWithClass_shouldCreateInstance(mockolatier), 5000);
        }
        
        private function strictWithClass_shouldCreateInstance(mockolate:Mockolatier):Function
		{
			return function (event:Event, data:Object=null):void 
			{
				var flavour:Flavour = mockolatier.strict(DarkChocolate);
            	assertThat(flavour, isA(DarkChocolate));
			}
        }
        
        //
        //  Stubbing Nicely
        //
        
        [Test(async, timeout=5000)]
        public function stubWithNice():void
        {
            Async.handleEvent(this, 
				mockolatier.prepare(DarkChocolate), 
				Event.COMPLETE, 
				stubWithNice_shouldCreateStubbingCouverture(mockolatier), 5000);
        }
        
        private function stubWithNice_shouldCreateStubbingCouverture(mockolate:Mockolatier):Function
        {
			return function (event:Event, data:Object=null):void 
			{
            	var flavour:Flavour = mockolatier.nice(DarkChocolate);
            	mockolatier.stub(flavour).method("name").returns("VeryDarkChocolate");
			}
        }
    }
}