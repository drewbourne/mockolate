---
layout: page
title: Stubbing and Mocking
author: Drew Bourne
---

## What can we make it do?

Once you have [prepared some Mockolate](preparing_and_creating.html), you probably want it to do something instead of just being given something false-y all the time. 

Both nice and strict Mockolates can be setup to do one or more of:

- return a value, or sequence of values
- dispatch an event
- call another function 
- throw an Error

## Stubbing and mocking

Mockolate supports adding _required_ behaviour using `mock(instance)` and _optional_ behaviour using `stub(instance)`. These required and optional behaviours are called `Expectation`s in Mockolate.

Any methods or properties with expectations added using `mock(instance)` MUST be used in the test before the Mockolate is [verified](verifying_and_test_spies.html), otherwise Mockolate will throw an `ExpectationError` telling you which expectations were not used. 

{% highlight as3 %}
var flavour:Flavour = nice(Flavour);
var yucky:Flavour = nice(Flavour);
var yummy:Flavour = nice(Flavour);

mock(flavour).method("combine").args(yummy);

flavour.combine(yucky);

verify(flavour);
{% endhighlight %}

Oh no, in the above example an `ExpectionError` is thrown because we called `flavour.combine()` with the wrong arguments. If we try that again with the correct arguments then our Mockolate will verify successfully.

{% highlight as3 %}
var flavour:Flavour = nice(Flavour);
var yucky:Flavour = nice(Flavour);
var yummy:Flavour = nice(Flavour);

mock(flavour).method("combine").args(yummy);

flavour.combine(yummy);

verify(flavour);
{% endhighlight %}

Methods or properties with behaviour added using `stub(instance)` are much nicer, and allow you add behaviour that might be used. 

## How to make Mockolates do something

In these examples we're going to skip the `[Test]` block and focus just on stubbing. All the usages of `stub(flavour)` in these examples could be replaced with `mock(flavour)` if we want to require that behaviour to be used. 

Using a nice Flavour, 

{% highlight as3 %}
var flavour:Flavour = nice(Flavour);
{% endhighlight %}
    
we can stub a getter,

{% highlight as3 %}
stub(flavour).getter("name").returns("Butterscotch");
{% endhighlight %}

or a setter,

{% highlight as3 %}
stub(flavour).setter("name").arg(true);
{% endhighlight %}

or a method with no arguments, and return a value,

{% highlight as3 %}
stub(flavour).method("toString").returns("Butterscotch");
{% endhighlight %}

stub a method with arguments, and return a reference,

{% highlight as3 %}
var otherFlavour:Flavour = nice(Flavour);
var combinedFlavour:Flavour = nice(Flavour);
stub(flavour).method("combine").args(otherFlavour).returns(combinedFlavour);
{% endhighlight %}
    
stub a method with arguments using Matchers from [hamcrest-as3](http://github.com/drewbourne/hamcrest-as3)

{% highlight as3 %}
stub(flavour).method("combine").args(instanceOf(Flavour))
    .returns(combinedFlavour);
{% endhighlight %}

stub a setter with arguments using Matchers, 

{% highlight as3 %}
stub(flavour).setter("ingredients").arg(array("cookies", "cream"));
{% endhighlight %}
    
stub a method to dispatch an Event,
  
{% highlight as3 %}
stub(flavour).method("combine").args(anything())
    .returns(combinedFlavour)
    .dispatches(new FlavourEvent(FlavourEvent.TASTE_EXPLOSION));
{% endhighlight %}
    
stub a method to call a Function,

{% highlight as3 %}
stub(flavour).method("combine").args(anything())
    .returns(combinedFlavour)
    .calls(function():void {
        trace("its a mystery flavour");
    });
{% endhighlight %}
        
stub a method to throw an Error,

{% highlight as3 %}
stub(flavour).method("combine").args(nullValue())
    .throws(new ArgumentError("Really, combine this flavour with <null>?"));
{% endhighlight %}

## Customising behaviour
    
Additional behaviour not included in Mockolate can be added by implementing `mockolate.ingredients.answers.Answer`. Examples of custom `Answer`s are provided for handing `HTTPService` result and fault calls. [Decorating Mocolates](decorating_mockolates.html) has more details.

## next [recording and replaying](recording_and_replaying.html)
