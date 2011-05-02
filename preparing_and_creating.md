---
layout: page
title: Preparing and Creating
author: Drew Bourne
---

## Preparing

<!--
_FIXME add a description about why Mockolates need to be prepared_
_FIXME link to the Flavour source_
-->

To prepare the Class you want to create Mockolates for use the `prepare(...classes)` function.
    
{% highlight as3 %}
[Before(async, timeout=5000)]
public function prepareMockolates():void
{
    Async.proceedOnEvent(this,
        prepare(Flavour, DarkChocolate),
        Event.COMPLETE);
}
{% endhighlight %}
    
Mockolates do take some time to prepare so we run this `[Before]` block asynchronously to allow the code generation backend to do its thing. 

See [Writing an Async Test](http://docs.flexunit.org/index.php?title=Writing_an_AsyncTest) in the [FlexUnit](http://flexunit.org/) [wiki](http://docs.flexunit.org/).

`prepare(Class)` can take more than one Class so go ahead and feed it as many as you like. Just be sure to wait till they are complete. 

## Creating Mockolates nicely, or strictly

Each Mockolate instance operates as a 'nice', or 'strict' Mock Object. 

- 'nice' Mock Objects will play nice and return false-y values for methods and properties that aren't mocked or stubbed. 
- 'strict' Mock Objects will whinge and cry if you mistreat them by calling methods that aren't mocked or stubbed. By whinge and cry I mean throw `InvocationError`s. 

Create a nice mock using `nice(ClassToMock)`, or a strict Mock using `strict(ClassToMock)` giving them the Class you want an instance of.

{% highlight as3 %}
[Test]
public function nicelyPlease():void 
{
    var flavour:Flavour = nice(Flavour);
    
    assertThat(flavour.name, nullValue());
}

[Test(expected="mockolate.errors.InvocationError")]
public function strictlyIfYouMust():void 
{
    var flavour:Flavour = strict(DarkChocolate);
    
    // accessing a property without a mock or stub 
    // will cause a strict Mock Object to throw an InvocationError
    var name:String = flavour.name;
}
{% endhighlight %}

## Creating partial Mock Objects

A 'partial' Mock Object will do whatever they usually do unless you tell them otherwise. Use a partial Mock Object when you must use most of the original behaviour of an Class overriding just a fraction of its behaviour. 

Create a partial Mock Object using `partial(ClassToMock)`. Set expectations as usual. Only methods and property that have behaviour added by Mockolate will be modified. 

*NOTE Using a partial Mock Object is atypical. Consider well if a 'nice' or 'strict' Mock Object is a better fit.*

## next [Preparing and Creating Easier](preparing_and_creating_easier.html)
