# Issues

* Expectation with never() receive count will never be eligible and hence never invoked and hence useless. Verification with never() is doable instead.

* add default stub() for toString() if instance has it, use Decorator pattern.

* Invocation.returnValue should be set from the last invoked Answer where isDefined(value) == true, instead of first

* Include invocations & order in errors to aid with debugging

* provide a compatibility shim for mock-as3. Partially done with `mockolate.ingredients.proxy.*`
