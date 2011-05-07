---
layout: page
title: Preparing and Creating a Little Bit Easier
author: Drew Bourne
---

Mockolate provides both a [FlexUnit Rule](http://docs.flexunit.org/index.php?title=CreatingRules) and a [FlexUnit runner](http://docs.flexunit.org/index.php?title=Runners_and_Builders) that can prepare and create nice and strict Mockolate instances based on metadata. Any `public` instance variable marked with `[Mock]` metadata will be prepared, and injected. Using the `MockolateRule` or `MockolateRunner` will take care of the asynchronous prepare step and will wait until the classes are prepared before running your tests. 

*NOTE variables marked with `[Mock]` MUST be public*

There are two options that may be given to `[Mock]`.

- use `[Mock(type="nice")]` to create a nice Mockolate (default).
- use `[Mock(type="strict")]` to create a strict Mockolate.
- use `[Mock(type="partial")]` to create a partial Mockolate.
- use `[Mock(inject="true")]` to inject the instance into the variable (default). 
- use `[Mock(inject="false")]` to prepare only, and not create a Mockolate.

There is one option that can be set per `[Test]`

- set `[Test(verify="false")]` to disable the automatic [verification](verifying_and_test_spies.html) of all Mockolates for that test. 

By default a nice Mockolate is created and injected. 

Using the `MockolateRule` for FlexUnit 4.1+

{% highlight as3 %}
public class ExampleWithRule
{
    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    
    [Mock(type="strict")]
    public var strictlyThanks:Example;
    
    [Mock(inject="false")]
    public var prepareButDontCreate:Example;
}
{% endhighlight %}

Using the `MockolateRunner` for FlexUnit 4

{% highlight as3 %}
// import and reference the runner to ensure it is compiled in.
import mockolate.runner.MockolateRunner; 
MockolateRunner; 

[RunWith("mockolate.runner.MockolateRunner")]
public class ExampleWithRunner
{
    [Mock]
    public var nicelyPlease:Example;
    
    [Mock(type="strict")]
    public var strictlyThanks:Example;
    
    [Mock(inject="false")]
    public var prepareButDontCreate:Example;
}
{% endhighlight %}

## next [stubbing and mocking](stubbing_and_mocking.html)
