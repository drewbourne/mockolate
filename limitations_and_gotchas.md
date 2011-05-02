---
layout: page
title: Limitations and Gotchas
author: Drew Bourne
---

# Limitations

Mockolate does have some limitations to what can be proxied. 

Stick with public methods and properties and you will be fine, (which is good design anyway as you should only be mocking public APIs). 

These are _no-nos_:

- Classes, methods, and properties marked `final`,
- Classes in the default (empty) package, 
- `static` methods and properties,
- `public var` variables,
- `public const` constants,
- `private` anything.

# Gotchas

Here's a couple of minor things that might surprise you the first time they happen.

## toString()

Classes or interfaces that explicitly define `toString():String` as a method, when invoked on a _nice_ Mockolate will return `null` unless a returns has been set.

{% highlight as3 %}
var flavour:Flavour = nice(Flavour);
trace(flavour) 
// outputs 'null'

stub(flavour).method('toString').noArgs().returns('My String');
trace(flavour);
// outputs 'My String'
{% endhighlight %}

## Constructor Parameters

Mockolate will supply `null`s as constructor arguments if none are supplied to `nice(Class)`, `strict(Class)` and `partial(Class)`. If your Class needs concrete instances pass them in.

## Default Parameters

All methods that are `mock()`ed, `stub()`bed, and `received()` will have default values included and these MUST be accounted for. For example, `EventDispatcher.addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReferences:Boolean = false)` has 3 parameters with default values. Calls to this method will always received 5 parameters.

## Classes in the default package 

At the moment if a Class is in the default package cannot be mocked. This is due to a bug or limitation of the bytecode library Mockolate uses to generate runtime Classes. 

{% highlight as3 %}
package 
{
    public class OhNo 
    {
        public function thisMethodIsNotProxied():void 
        {
        }
    }
}
{% endhighlight %}







