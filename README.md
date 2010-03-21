# Mockolate. fake chocolate, mock objects and test spies. 

[Drew Bourne](mailto:andrew@firstbourne.com)

## Mockolate, what what?

In the delicious land of AS3 you can now create the finest Mock Objects and Test Spies. 

## how to get Mockolate

Got Git? Awesome, you're allowed in the kitchen.

    $ git clone git://github.com/drewbourne/mockolate.git

## now to make some Mockolate yourself

First things first, a few assumptions: 

1. we're going to use [FlexUnit 4](http://opensource.adobe.com/wiki/display/flexunit/FlexUnit). 
1. and a bit of [hamcrest-as3](http://github.com/drewbourne/hamcrest-as3). 

Thats enough for now. 

## preparing, getting your ingredients ready

To prepare the Class you want to create Mockolates for we use the 'prepare(Class)' function.
    
    import mockolate.prepare;
    
    import mockolate.sample.Flavour;
    import mockolate.sample.DarkChocolate;
        
    [Before(async, timeout=5000)]
    public function prepareMockolates():void
    {
        Async.proceedOnEvent(this,
            prepare(Flavour, DarkChocolate),
            Event.COMPLETE);
    }
    
Mockolates do take some time to prepare so we run this [Before] block asynchronously to allow the code generation backend to do its thing.

'prepare(Class)' can take more than one Class so go ahead and feed it as many as you like. Just be sure to wait till they are complete. 

## creating Mockolates nicely, or strictly

Each Mockolate instance operates as either a 'nice' Mock or a 'strict' Mock Object. 

- 'nice' Mocks will play nice and return false-y values for methods and properties that aren't stubbed. 
- 'strict' Mocks will whinge and cry if you mistreat them by calling methods that aren't stubbed. 

Create a nice mock using 'nice(Class)', or a strict Mock using 'strict(Class)' giving them the Class you want an instance of.

    [Test]
    public function nicelyPlease():void 
    {
        var flavour:Flavour = nice(Flavour);
        
        assertThat(flavour.name, nullValue());
    }

    [Test(expected="mockolate.mistakes.StubMissingError")]
    public function strictlyIfYouMust():void 
    {
        var flavour:Flavour = strict(DarkChocolate);
        
        // just accessing a property without a stub will cause a strict to throw a StubMissingError
        var name:String = flavour.name;
    }


## stubbing your toe, err Mock

Once you have some Mockolate, you probably want it to do something instead of just being given something false-y all the time. 

Both nice and strict Mock can be stubbed to do one or more of:

- return a value, or sequence of values
- dispatch an event
- call another function 
- throw an Error

Stubs are defined with the 'stub(instance)' function. In these examples we're going to skip the [Test] block and focus just on stubbing. 

    import mockolate.stub;

    // get our instance to stub
    var flavour:Flavour = nice(Flavour);
    
    // stub a getter
    stub(flavour).property("name").returns("Butterscotch");

    // stub a setter
    stub(flavour).property("name").args(true);

    // stub a method
    stub(flavour).method("toString").returns("Butterscotch");
    
    // stub a method with arg values
    var otherFlavour:Flavour = nice(Flavour);
    var combinedFlavour:Flavour = nice(Flavour);
    stub(flavour).method("combine").args(otherFlavour).returns(combinedFlavour);
    
    // stub a method with arg Matchers
    stub(flavour).method("combine").args(instanceOf(Flavour)).returns(combinedFlavour);
    
    // stub a method to dispatch an Event
    stub(flavour).method("combine").args(anything()).returns(combineFlavour).dispatches(new FlavourEvent(FlavourEvent.TASTE_EXPLOSION));
    
    // stub a method to call a Function
    stub(flavour).method("combine").args(anything()).returns(combineFlavour).calls(function():void {
      trace("its mystery flavour");
    });
        
    // stub a method to throw an Error
    stub(flavour).method("combine").args(nullValue()).throws(new ArgumentError("Do you really want to combine this flavour with <null>?"));

## verifying Mockolates

For all strict Mocks an easy call to 'verify(instance)' will check that all the stubbed methods have been called at least once. 

    import mockolate.verify;

    [Test]
    public function verifyThusly():void 
    {
        var flavour:Flavour = strict(Flavour);
        stub(flavour).property("name").returns("");
        
        // use our mockolate
        var name:String = flavour.name;
        
        // its a good thing we called 'flavour.name' else we would have got a mockolate.errors.VerifyFailedError.
        verify(flavour);
    }

## spying on Mockolates

Spying on Mockolates is a little bit like verifying and a lot more like stubbing. Spying works on a cascade system where each additional verification step we add narrows the acceptable range of how a method or property should have been called. 

    [Test]
    public function iSpyWithMyLittleEye():void 
    {
        var flavour:Flavour = nice(Flavour);
        var otherFlavour:Flavour = nice(Flavour);
        
        // ... do some work with the instances.
      
        // check that flavour.name was called at all.
        verify(flavour).method("name");
        
        // check that flavour.combine() was called with any args
        verify(flavour).method("combine").args(anything());
        
        // check that flavour.combine() was called with a specific instance of flavour
        verify(flavour).method("combine").args(strictlyEqualTo(otherFlavour));        
        
        // check that flavour.combine() was called with a number of flavours, any instance.
        verify(flavour).method("combine").args(instanceOf(DarkChocolate), instanceOf(Flavour));
        
        // check that flavour.combine() was called at least 3 times
        verify(flavour).method("combine").atLeast(3);
    }

## notes

Mockolate internals is currently a bit rough and are being whipped into shape rather promptly. If theres a test or example and its passes, then that feature possibly works. Anything outside the tests and examples is unspecified, or unimplemented, or likely to change. Even the things in the tests and examples may well be under-specified. User beware and all that. 

## thanks

Richard Szalay with [FLoxy](http://code.google.com/p/floxy/), and Maxim Porges with [Loom](http://code.google.com/p/loom-as3/) for their work on Class proxy generation. 

Brian LeGros for hassling me about [mock-as3](http://code.google.com/p/mock-as3/) enough that I added class proxy generation to it. Except you can probably ignore that project in favour of Mockolate.
