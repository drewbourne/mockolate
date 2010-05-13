---
layout: page
title: Mockolate
author: Drew Bourne
---

# fake chocolate, mock objects and test spies for AS3

The object names are probably a hint that Mockolate is most useful when testing software. Whether you are doing _test-driven-development_, _post-crunch-time fill-in-the-gaps_, or _exploratory-I-have-no-idea-what-is-going-on_ testing Mockolate can help.

# Mock Objects

A mock object can be used to simulate the behaviour of complex, real (non-mock) objects when using the real object would be impractical or impossible. Situations where a mock object would be useful: 

- When an object is slow (like a database or webservice),
- is non-deterministic (like current time), 
- has states that are difficult to reproduce (like network)

The above is mostly appropriated from [Mock Objects at Wikipedia](http://en.wikipedia.org/wiki/Mock_object). I could keep rewriting it here, but it's really quite a good read. 

# Test Spies

In espionage, spies infiltrate a system, recording and relaying information to their handlers. The handlers may use that information to check facts, inform others, or take action. 

In testing, a Test Spy records which methods are called, which getters are got, which setters are set. The handler (typically a testcase) can then check the facts against what should or should not have happened and take action (typically an assertion). 

# Mockolate?

- expectation-based
- clean consistent syntax
- dynamically generates proxy Classes
- supports handcoded proxy Classes
- provides a FlexUnit 4 runner
- uses proven libraries, FlexUnit 4, FLoxy and hamcrest-as3

<!--
FIXME more explanation here thanks!
-->

# next [getting Mockolate](getting_mockolate.html)
