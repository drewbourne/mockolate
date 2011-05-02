---
layout: page
title: Getting Mockolate
author: Drew Bourne
---

## How to get Mockolate

### Need a SWC?

It's been baked along with the ASDocs, get the latest from the [Mockolate Downloads](https://github.com/drewbourne/mockolate/downloads). 

### Let me build it myself

Got Git? Awesome, you're allowed in the kitchen. 
{% highlight bash %}
$ git clone git://github.com/drewbourne/mockolate.git
{% endhighlight %}
    
Got Subversion? Not quite as awesome, but you can play too.
{% highlight bash %}
$ svn checkout http://svn.github.com/drewbourne/mockolate.git
{% endhighlight %}

Once you've checked out the Mockolate source, run:
{% highlight bash %}
$ ant clean package
{% endhighlight %}

And you'll find in the `target/bin` folder the SWCs, in `target/docs` the ASDocs, and if you have FlexPMD available in `target/report` are the CPD, PMD, and FlexUnit reports. 

## Now to use some Mockolate yourself

Once you've got Mockolate, you may need a few other pieces too. 

We're going to use [FlexUnit 4](http://opensource.adobe.com/wiki/display/flexunit/FlexUnit) for tests, and a bit of [hamcrest-as3](http://github.com/drewbourne/hamcrest-as3) for matching arguments.

## next [preparing and creating](preparing_and_creating.html)



