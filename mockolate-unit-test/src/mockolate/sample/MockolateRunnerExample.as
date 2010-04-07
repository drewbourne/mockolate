package mockolate.sample
{
   import mockolate.mock;
   
   import org.flexunit.assertThat;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;

   [RunWith("mockolate.runner.MockolateRunner")]
   public class MockolateRunnerExample
   {
      [Mock]
      public var nicelyImplicitlyInjected : Example;

      [Mock(type="strict")]
      public var strictlyImplicitlyInjected : Example;

      [Mock(type="nice", inject="true")]
      public var nicelyExplicitlyInjected : Example;
      //
      [Mock(type="strict", inject="true")]
      public var strictlyExplicitlyInjected : Example;
      //
      [Mock(type="nice", inject="false")]
      public var nicelyExplicitlyNotInjected : Example;

      [Mock(type="strict", inject="false")]
      public var strictlyExplicitlyNotInjected : Example;

      [Before]
      public function mocksShouldBeAvailableInBefore () : void
      {
         assertThat("nicely implicitly injected",  nicelyImplicitlyInjected,  notNullValue());
         assertThat("strictly implicitly injected",  strictlyImplicitlyInjected,  notNullValue());
         assertThat("nicely explicity injected",  nicelyExplicitlyInjected,  notNullValue());
         assertThat("strictly explicity injected",  strictlyExplicitlyInjected,  notNullValue());
         assertThat("nicely explicitly not injected",  nicelyExplicitlyNotInjected,  nullValue());
         assertThat("strictly explicitly not injected",  strictlyExplicitlyNotInjected,  nullValue());
      }

      [Test]
      public function mocksShouldBeAvailableInTests () : void
      {
         assertThat("nicely implicitly injected",  nicelyImplicitlyInjected,  notNullValue());
         assertThat("strictly implicitly injected",  strictlyImplicitlyInjected,  notNullValue());
         assertThat("nicely explicity injected",  nicelyExplicitlyInjected,  notNullValue());
         assertThat("strictly explicity injected",  strictlyExplicitlyInjected,  notNullValue());

         assertThat("nicely explicitly not injected",  nicelyExplicitlyNotInjected,  nullValue());
         assertThat("strictly explicitly not injected",  strictlyExplicitlyNotInjected,  nullValue());
      }

      // Cannot use expected error for Mock Errors as the expects metadata is processed before the automatic mock verification
      // [Test(expected="com.anywebcam.mock.MockExpectationError")]
      [Test]
      public function mocksShouldBeAutomaticallyVerified () : void
      {
         var expected : String = "how long is a piece of string";

         mock(strictlyImplicitlyInjected).method("giveString").noArgs().returns(expected).once();
         
         assertThat(strictlyImplicitlyInjected.giveString(),  equalTo(expected));
      }

      // remove the [Ignore] for the test as an example of a mock failing auto-verification. 
      [Test]
      public function mocksShouldBeAutomaticallyVerified2 () : void
      {
        var expected : String = "how long is a piece of string";

        mock(strictlyImplicitlyInjected).method("giveString").args(1, 2, 3).returns(expected).once();
        mock(strictlyExplicitlyInjected).method("giveString").args(4, 5, 6).returns(expected).once();
         
         // dont call, should fail verification
         // assertThat(strictlyImplicitlyInjected.giveString(),  equalTo(expected));
      }

      [Test(verify="false")]
      public function mocksShouldNotBeAutomaticallyVerified () : void
      {
         var expected : String = "how long is a piece of string";

         mock(strictlyImplicitlyInjected).method("giveString").noArgs().returns(expected).once();
      }
   }
}