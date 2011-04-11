package mockolate
{
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
    
    public class StubbingMockolates
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
           Stubbing for nice and strict mocks
        
           // stub api
           // stub: method
           // stub: property
           stub(instance:*, propertyOrMethod:String, ...matchers):Stub
           // stub: argument matchers
           .args(...matchers)
           // stub: return value
           .returns(value:*)
           .returns(value:Answer)
           // stub: throw error
           .throws(error:Error)
           // stub: function call
           .calls(fn:Function)
           // stub: event dispatch
           .dispatches(event:Event, delay:Number=0)
           // expect: receive count, useful to change/sequence return values
           .times(n:int)
           .never()
           .once() // strict mock stubs/expectations default to once()
           .twice()
           .thrice()
           .atLeast(n:int) // nice mocks default to atLeast(0)
           .atMost(n:int)
           // stub: expectation ordering
           .ordered(group:String="global")
         */
        
        [Test]
        public function stubbingGetter():void
        {
            var instance:Flavour = nice(Flavour);
            var answer:Object = "Butterscotch";
            
            stub(instance).getter("name").returns(answer);
            
            assertThat(instance.name, strictlyEqualTo(answer));
        }

        // getter throws
        // setter throws
        // getter calls
        // setter calls
        // getter dispatches event
        // setter dispatches event
         
        [Test]
        public function stubbingMethod():void
        {
            var instance:Flavour = nice(Flavour);
            var answer:Object = nice(Flavour);
            
            stub(instance).method("combine").args(nullValue()).returns(answer);
            
            assertThat(instance.combine(null), strictlyEqualTo(answer));
        }
        
        [Test]
        public function stubbingMethodWithArgs():void
        {
            var instance:Flavour = nice(Flavour);
            var arg:Flavour = new DarkChocolate();
            var answer:Flavour = nice(Flavour);
            
            stub(instance).method("combine").args(arg).returns(answer);
            
            assertThat(instance.combine(arg), strictlyEqualTo(answer));
        }
        
        [Test]
        public function stubbingMethodWithArgMatchers():void
        {
            var instance:Flavour = nice(Flavour);
            var arg:Flavour = new DarkChocolate();
            var answer:Flavour = nice(Flavour);
            
            stub(instance).method("combine").args(strictlyEqualTo(arg)).returns(answer);
            
            assertThat(instance.combine(arg), strictlyEqualTo(answer));
        }
        
        [Test(expected='mockolate.sample.FlavourMismatchError')]
        public function stubbingMethodToThrowError():void 
        {
            var instance:Flavour = nice(Flavour);
            var arg1:Flavour = nice(Flavour, 'Anchovies');
            var arg2:Flavour = nice(Flavour, 'IceCream');
            var answer:Flavour = nice(Flavour);
            
            stub(instance).method("combine").args(arg1, arg2).throws(new FlavourMismatchError("Eww, Anchovies and IceCream dont mix"));
            
            instance.combine(arg1, arg2);        	
        }
        
        [Test]
        public function stubbingMethodToCallFunction():void 
        {
            var called:Boolean = false;
            var instance:Flavour = nice(Flavour);
            
            stub(instance).method("combine").args(anything()).calls(function():void {
                called = true;	
            });
            
            instance.combine(null);
            
            assertThat(called, equalTo(true));
        }
        
        [Test]
        public function stubbingMethodToDispatchEvent():void 
        {
            var dispatched:Boolean = false;
            var instance:DarkChocolate = nice(DarkChocolate);
          
            stub(instance).method("combine").args(anything()).dispatches(new Event("flavoursCombined"));
          
            instance.addEventListener("flavoursCombined", function(event:Event):void {
                dispatched = true;
            });
            
            instance.combine(null);
            
            assertThat(dispatched, equalTo(true));
        }
    }
}