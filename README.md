# Mockolate. 
# fake chocolate, mock objects and test spies. 

[mockolate.org](http://mockolate.org/) Documentation, examples, elaboration. 
[Drew Bourne](mailto:drew@firstbourne.com) Contact.

This tagline is probably a hint that Mockolate is most useful when testing software. Whether you are doing _test-driven-development_, _post-crunch-time fill-in-the-gaps_, or _exploratory-I-have-no-idea-what-is-going-on_ testing Mockolate can help.

# Mock Objects

A mock object can be used to simulate the behaviour of complex, real (non-mock) objects when using the real object would be impractical or impossible. Situations where a mock object would be useful: 

- When an object is slow (like a database or webservice),
- is non-deterministic (like the current time), 
- has states that are difficult to reproduce (like network connections)

The above is mostly appropriated from [Mock Objects at Wikipedia](http://en.wikipedia.org/wiki/Mock_object). I could keep rewriting it here, but it's really quite a good read. 

# Test Spies

In espionage, spies infiltrate a system, recording and relaying information to their handlers. The handlers may use that information to check facts, inform others, or take action. 

In testing, a Test Spy records which methods are called, which getters are got, which setters are set. The handler (typically a testcase) can then check the facts against what should or should not have happened and take action (typically an assertion). 

# Mockolate?

- clean consistent syntax
- expectation-based or record-replay
- dynamically generates proxy Classes
- supports handcoded proxy Classes
- provides a FlexUnit 4 Rule and Runner
- uses proven libraries, [FlexUnit 4](http://flexunit.org/), [FLoxy](http://code.google.com/p/floxy) and [Hamcrest-as3](http://github.com/drewbourne/hamcrest-as3)

# Next

Head over to [http://mockolate.org/](http://mockolate.org/) for documentation and examples:

- [Mockolate?](http://mockolate.org/mockolate.html)
- [Getting Mockolate](http://mockolate.org/getting_mockolate.html)
- [Preparing and Creating](http://mockolate.org/preparing_and_creating.html)
- [Stubbing and Mocking](http://mockolate.org/stubbing_and_mocking.html)
- [Recoding and Replaying](http://mockolate.org/recording_and_replaying.html)
- [Verifying and Test Spies](http://mockolate.org/verifying_and_test_spies.html)
- [Decorating Mockolates](http://mockolate.org/decorating_mockolates.html)
- [Limitations and Gotchas](http://mockolate.org/limitations_and_gotchas.html)

## Thanks

Richard Szalay with [FLoxy](http://code.google.com/p/floxy/), and Maxim Porges with [Loom](http://code.google.com/p/loom-as3/) for their work on Class proxy generation. 

Brian LeGros for hassling me about -mock-as3- enough that I added class proxy generation to it. Except you can ignore that project in favour of Mockolate.
