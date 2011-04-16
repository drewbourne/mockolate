---
layout: page
title: Recording and Replaying
author: Drew Bourne
---

## How to make Mockolates do something (alternate syntax)

In [stubbing and mocking](stubbing_and_mocking.html) the default _expectation-based_ syntax was demonstrated, however Mockolate also supports a _record-replay_ syntax for refactoring-friendly Mock Objects. To start using this syntax pass a Mockolate-created instance to `record(instance)`, call any methods, getters and setters that are expected and then call `replay(instance)` before passing the instance to whatever is going to use the it. Some expectations will use `expect(...)` to set additional behaviour.

Using a nice Flavour, 

{% highlight as3 %}
var flavour:Flavour = nice(Flavour);
{% endhighlight %}

set it to record,

{% highlight as3 %}
record(flavour);
{% endhighlight %}
    
we can stub a getter,

{% highlight as3 %}
expect(flavour.name).returns("Butterscotch");
{% endhighlight %}

or a setter,

{% highlight as3 %}
expect(flavour.name = true);
{% endhighlight %}

or a method with no arguments, and return a value,

{% highlight as3 %}
expect(flavour.toString()).returns("Butterscotch");
{% endhighlight %}

stub a method with arguments, and return a reference,

{% highlight as3 %}
var otherFlavour:Flavour = nice(Flavour);
var combinedFlavour:Flavour = nice(Flavour);
expect(flavour.combine(otherFlavour)).returns(combinedFlavour);
{% endhighlight %}
    
stub a method with arguments using Matchers from [hamcrest-as3](http://github.com/drewbourne/hamcrest-as3)

{% highlight as3 %}
expect(flavour.combine(expectArg(instanceOf(Flavour)))).returns(combinedFlavour);
{% endhighlight %}

stub a setter with arguments using Matchers, 

{% highlight as3 %}
expect(flavour.ingredients = expectArg(array("cookies", "cream")));
{% endhighlight %}
    
stub a method to dispatch an Event,
  
{% highlight as3 %}
expect(flavour.combine(expectArg(anything)))
    .returns(combinedFlavour)
    .dispatches(new FlavourEvent(FlavourEvent.TASTE_EXPLOSION));
{% endhighlight %}
    
stub a method to call a Function,

{% highlight as3 %}
expect(flavour.combine(expectArg(anything())))
    .returns(combinedFlavour)
    .calls(function():void {
        trace("it's a mystery flavour");
    });
{% endhighlight %}
        
stub a method to throw an Error,

{% highlight as3 %}
expect(flavour.combine(expectArg(nullValue())))
    .throws(new ArgumentError("Really, combine this flavour with <null>?"));
{% endhighlight %}

and finally before using the instance for real, call `replay()`

{% highlight as3 %}
replay(flavour);
{% endhighlight %}
    
## Customising behaviour
    
Additional behaviour not included in Mockolate can be added by implementing `mockolate.ingredients.answers.Answer`. Examples of custom `Answer`s are provided for handing `HTTPService` result and fault calls. [Decorating Mocolates](decorating_mockolates.html) has more details.

## next [verifying and test spies](verifying_and_test_spies.html)
