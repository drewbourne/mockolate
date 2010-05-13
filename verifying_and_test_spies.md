---
layout: page
title: Verifying and Test Spies
author: Drew Bourne
---

## Verifying Mockolates

For all strict Mockolates an easy call to `verify(instance)` will check that all the `mock(instance)` expectations have been called their expected number of times (at least once, unless changed). 

{% highlight actionscript %}
import mockolate.verify;

[Test]
public function verifyThusly():void 
{
    var flavour:Flavour = strict(Flavour);
    mock(flavour).property("name").returns("");
    
    // use our mockolate
    var name:String = flavour.name;
    
    verify(flavour);
}
{% endhighlight %}
    
It's a good thing we called `flavour.name` else we would have got a `mockolate.errors.ExpectationError`.

## Spying on Mockolates

Spying on Mockolates is a little bit like verifying and a lot more like stubbing. Spying works on a cascade system where each additional verification step we add narrows the acceptable range of how a method or property should have been called. 

{% highlight actionscript %}
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
{% endhighlight %}
    
When adding a new step to the verification criteria if there no invocations that match then a `VerificationError` will be throw. 

