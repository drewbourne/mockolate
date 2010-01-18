# Issues

* Expectation invoke count & eligibility is not calculated correctly for fixed receive counts.
    eg: mock(instance).method("say").times(3);
    
* Expectation with never() receive count will never be eligible and hence never invoked and hence useless. 

* add default stub() for toString() if instance has it.

* Invocation.returnValue should be set from the last invoked Answer where isDefined(value) == true, instead of first

* Include invocations & order in errors to aid with debugging