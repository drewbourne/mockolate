package mockolate
{
    import asx.object.isA;
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    
    import mockolate.ingredients.Mockolate;
    import mockolate.sample.DarkChocolate;
    import mockolate.sample.Flavour;
    import mockolate.sample.FlavourMismatchError;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.anything;
    import org.hamcrest.core.not;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.nullValue;
    import org.hamcrest.object.strictlyEqualTo;
    
    public class MockingMockolates
    {
        // shorthands
        public function proceedWhen(target:IEventDispatcher, eventName:String, timeout:Number=30000, timeoutHandler:Function=null):void
        {
            Async.proceedOnEvent(this, target, eventName, timeout, timeoutHandler);
        }
        
        [Before(async, timeout=30000)]
        public function prepareMockolates():void
        {
            proceedWhen(
                prepare(Flavour, DarkChocolate),
                Event.COMPLETE);
        }
        
        /*
           Mocking for nice and strict mocks
        
           // mock api
           // mock: method
           mock(instance:*).method(methodName:String):Stub
           // mock: property
           mock(instance:*).property(propertyName:String):Stub
           // mock: argument matchers
           // methods
           .args(...valuesOrMatchers)
           // properties
           .arg(valueOrMatcher);
           // mock: return value
           .returns(value:*)
           .returns(value:Answer)
           // mock: throw error
           .throws(error:Error)
           // mock: function call
           .calls(fn:Function)
           // mock: event dispatch
           .dispatches(event:Event, delay:Number=0)
           // expect: receive count, useful to change/sequence return values
           .times(n:int)
           .never()
           .once() // strict mock mocks/expectations default to once()
           .twice()
           .thrice()
           .atLeast(n:int) // nice mocks default to atLeast(0)
           .atMost(n:int)
           // mock: expectation ordering
           .ordered(group:String="global")
         */
        
        [Test]
        public function mockingPropertyGetter():void
        {
            var instance:Flavour = nice(Flavour);
            var answer:Object = "Butterscotch";
            
            mock(instance).property("name").returns(answer);
            
            assertThat(instance.name, strictlyEqualTo(answer));
        }

        // getter throws
        // setter throws
        // getter calls
        // setter calls
        // getter dispatches event
        // setter dispatches event
         
        [Test]
        public function mockingMethod():void
        {
            var instance:Flavour = nice(Flavour);
            var answer:Object = nice(Flavour);
            
            mock(instance).method("combine").args(nullValue()).returns(answer);
            
            assertThat(instance.combine(null), strictlyEqualTo(answer));
        }
        
        [Test]
        public function mockingMethodWithArgs():void
        {
            var instance:Flavour = nice(Flavour);
            var arg:Flavour = new DarkChocolate();
            var answer:Flavour = nice(Flavour);
            
            mock(instance).method("combine").args(arg).returns(answer);
            
            assertThat(instance.combine(arg), strictlyEqualTo(answer));
        }
        
        [Test]
        public function mockingMethodWithArgMatchers():void
        {
            var instance:Flavour = nice(Flavour);
            var arg:Flavour = new DarkChocolate();
            var answer:Flavour = nice(Flavour);
            
            mock(instance).method("combine").args(strictlyEqualTo(arg)).returns(answer);
            
            assertThat(instance.combine(arg), strictlyEqualTo(answer));
        }
        
        [Test(expected='mockolate.sample.FlavourMismatchError')]
        public function mockingMethodToThrowError():void 
        {
            var instance:Flavour = nice(Flavour);
            var arg1:Flavour = nice(Flavour, 'Anchovies');
            var arg2:Flavour = nice(Flavour, 'IceCream');
            var answer:Flavour = nice(Flavour);
            
            mock(instance).method("combine").args(arg1, arg2).throws(new FlavourMismatchError("Eww, Anchovies and IceCream dont mix"));
            
            instance.combine(arg1, arg2);        	
        }
        
        [Test]
        public function mockingMethodToCallFunction():void 
        {
        	var called:Boolean = false;
        	var instance:Flavour = nice(Flavour);
        	
        	mock(instance).method("combine").args(anything()).calls(function():void {
        		called = true;	
        	});	
        	
        	instance.combine(null);
        	
        	assertThat(called, equalTo(true));
        }
        
        [Test]
        public function mockingMethodToDispatchEvent():void 
        {
        	var dispatched:Boolean = false;
			var instance:DarkChocolate = nice(DarkChocolate);
			
			mock(instance).method("combine").args(anything()).dispatches(new Event("flavoursCombined"));
			
			instance.addEventListener("flavoursCombined", function(event:Event):void {
				dispatched = true;
			});
			
			instance.combine(null);
			
			assertThat(dispatched, equalTo(true));
        }        
    }
}