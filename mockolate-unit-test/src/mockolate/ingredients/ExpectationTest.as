package mockolate.ingredients
{
	import mockolate.*;
	import mockolate.ingredients.faux.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.*;
	import org.hamcrest.number.*;
	import org.hamcrest.object.*;

	use namespace mockolate_ingredient;

	public class ExpectationTest
	{
		public var expectation:Expectation;
		public var invocation:Invocation;

		[Before]
		public function setup():void 
		{
			expectation = new Expectation();
		}

		[Test]
		public function name_should_get_and_set():void 
		{
			expectation.name = 'TEST_NAME';
			assertThat('expectation.name', expectation.name, equalTo('TEST_NAME'));
		}

		[Test]
		public function namespaceURI_should_get_and_set():void 
		{
			expectation.namespaceURI = 'TEST_NAMESPACE';
			assertThat('expectation.namespaceURI', expectation.namespaceURI, equalTo('TEST_NAMESPACE'));
		}

		[Test]
		public function nameMatcher_should_get_and_set():void 
		{
			expectation.nameMatcher = equalTo('TEST_NAME');
			assertThat('expectation.nameMatcher', 'TEST_NAME', expectation.nameMatcher);
		}

		[Test]
		public function invocationType_as_getter_should_get_and_set():void 
		{
			expectation.invocationType = InvocationType.GETTER;
			assertThat('expectation.invocationType GETTER', expectation.invocationType, equalTo(InvocationType.GETTER));
			assertThat('expectation.isGetter', expectation.isGetter, isTrue());
			assertThat('expectation.isSetter', expectation.isSetter, isFalse());
			assertThat('expectation.isMethod', expectation.isMethod, isFalse());
		}

		[Test]
		public function invocationType_as_setter_should_get_and_set():void 
		{
			expectation.invocationType = InvocationType.SETTER;
			assertThat('expectation.invocationType SETTER', expectation.invocationType, equalTo(InvocationType.SETTER));
			assertThat('expectation.isGetter', expectation.isGetter, isFalse());
			assertThat('expectation.isSetter', expectation.isSetter, isTrue());
			assertThat('expectation.isMethod', expectation.isMethod, isFalse());
		}

		[Test]
		public function invocationType_as_method_should_get_and_set():void 
		{
			expectation.invocationType = InvocationType.METHOD;
			assertThat('expectation.invocationType METHOD', expectation.invocationType, equalTo(InvocationType.METHOD));
			assertThat('expectation.isGetter', expectation.isGetter, isFalse());
			assertThat('expectation.isSetter', expectation.isSetter, isFalse());
			assertThat('expectation.isMethod', expectation.isMethod, isTrue());
		}

		[Test]
		public function argsMatcher_should_get_and_set():void 
		{

		}

		[Test]
		public function invokeCountEligiblityMatcher_should_get_and_set():void 
		{

		}

		[Test]
		public function should_be_eligibleByInvocationCount_without_invokeCountEligibilityMatcher():void 
		{
			expectation.invokeCountEligiblityMatcher = null;

			assertThat("before invoked", expectation.eligibleByInvocationCount(), isTrue());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked", expectation.eligibleByInvocationCount(), isTrue());
		}

		[Test]
		public function should_be_eligibleByInvocation_with_matching_invokeCountEligibilityMatcher():void 
		{
			expectation.invokeCountEligiblityMatcher = lessThanOrEqualTo(1);

			assertThat("before invoked", expectation.eligibleByInvocationCount(), isTrue());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked", expectation.eligibleByInvocationCount(), isFalse());
		}

		[Test]
		public function should_be_eligibleByInvocation_with_mismatched_invokeCountEligibilityMatcher():void 
		{
			expectation.invokeCountEligiblityMatcher = lessThanOrEqualTo(2);

			assertThat("before invoked", expectation.eligibleByInvocationCount(), isTrue());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked", expectation.eligibleByInvocationCount(), isTrue());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked to limit", expectation.eligibleByInvocationCount(), isFalse());
		}

		[Test]
		public function invokeCountVerificationMatcher_should_get_and_set():void 
		{

		}

		[Test]
		public function should_be_satisfied_without_invokeCountVerificationMatcher():void 
		{
			expectation.invokeCountVerificationMatcher = null;

			assertThat("before invoked", expectation.satisfied, isTrue());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked", expectation.satisfied, isTrue());
		}

		[Test]
		public function should_be_satisfied_with_matching_invokeCountVerificationMatcher():void 
		{
			expectation.invokeCountVerificationMatcher = equalTo(1);

			assertThat("before invoked", expectation.satisfied, isFalse());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked", expectation.satisfied, isTrue());
		}

		[Test]
		public function should_be_satisfied_with_mismatched_invokeCountVerificationMatcher():void 
		{
			expectation.invokeCountVerificationMatcher = equalTo(2);

			assertThat("before invoked", expectation.satisfied, isFalse());

			expectation.invoke(new FauxInvocation());
			expectation.invoke(new FauxInvocation());

			assertThat("after invoked", expectation.satisfied, isTrue());

			expectation.invoke(new FauxInvocation());

			assertThat("after invoked too many times", expectation.satisfied, isFalse());
		}
	}
}