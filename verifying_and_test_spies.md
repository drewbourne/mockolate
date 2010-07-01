---
layout: page
title: Verifying and Test Spies
author: Drew Bourne
---

## Verifying Mockolates

For all strict Mockolates an easy call to `verify(instance)` will check that all the `mock(instance)` expectations have been called their expected number of times (at least once, unless changed). 

{% highlight as3 %}
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

Using Test Spies in Mockolate is a combination of assertions and the Mockolate stubbing interface. To determine what methods, getters, and setters were called on a Mockolate instance use `assertThat()` and the `received()` Matcher. 

{% highlight as3 %}
[Test]
public function iSpyWithMyLittleEye():void 
{
    var flavour:Flavour = nice(Flavour);
    var otherFlavour:Flavour = nice(Flavour);
    
    // ... do some work with the instances.
  
    // check that flavour.name was called at all.
    assertThat(flavour, received().method('name'));
    
    // check that flavour.combine() was called with any args
    assertThat(flavour, received().method('combine').args(anything()));
    
    // check that flavour.combine() was called with a specific instance of flavour
    assertThat(flavour, received().method('combine').args(strictlyEqualTo(otherFlavour)));
    
    // check that flavour.combine() was called with a number of flavours, any instance.
    assertThat(flavour, received().method('combine').args(instanceOf(DarkChocolate), instanceOf(Flavour)));
    
    // check that flavour.combine() was called at least 3 times
    assertThat(flavour, received().method('combine').atLeast(3));
    
    // check that flavour.combine() was never called
    assertThat(flavour, received().method('combine').args(Curry, IceCream).never());
}
{% endhighlight %}

## next [decorating mockolates](decorating_mockolates.html)
