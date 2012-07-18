package mockolate
{
	import flash.events.Event;
	
	import mockolate.ingredients.Capture;
	import mockolate.ingredients.CaptureType;
	import mockolate.ingredients.Sequence;
	import mockolate.sample.Flavour;
	import mockolate.runner.MockolateRule;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.strictlyEqualTo;

	public class UsingCapturedArguments
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(inject="false")]
		public var flavourA:Flavour;

		[Mock(inject="false")]
		public var flavourB:Flavour;

		[Mock(inject="false")]
		public var flavourC:Flavour;
				
		[Test(expected="mockolate.errors.CaptureError")]
		public function shouldComplainIfNoCapturedValue():void 
		{
			var captured:Capture = new Capture();
			
			captured.value;
		}
		
		[Test]
		public function captureShouldStoreValue():void 
		{
			var captured:Capture = new Capture();
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			
			mock(flavourA).method("combine").args(capture(captured));
			
			flavourA.combine(flavourB);
			
			assertThat(captured.value, strictlyEqualTo(flavourB));
		}
		
		[Test]
		public function captureAllShouldCaptureAllValues():void 
		{
			var captured:Capture = new Capture(CaptureType.ALL);
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			flavourC = nice(Flavour);
			
			mock(flavourA).method("combine").args(capture(captured));
			
			flavourA.combine(flavourB);
			flavourA.combine(flavourB);
			flavourA.combine(flavourC);
			
			assertThat(captured.values, array(flavourB, flavourB, flavourC));
		}
		
		[Test]
		public function captureFirstShouldCaptureFirstValue():void 
		{
			var captured:Capture = new Capture(CaptureType.FIRST);
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			flavourC = nice(Flavour);
			
			mock(flavourA).method("combine").args(capture(captured));
			
			flavourA.combine(flavourB);
			flavourA.combine(flavourB);
			flavourA.combine(flavourC);
			
			assertThat(captured.value, strictlyEqualTo(flavourB));
			assertThat(captured.values, array(flavourB));			
		}
		
		[Test]
		public function captureLastShouldCaptureLastValue():void 
		{
			var captured:Capture = new Capture(CaptureType.LAST);
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			flavourC = nice(Flavour);
			
			mock(flavourA).method("combine").args(capture(captured));
			
			flavourA.combine(flavourB);
			flavourA.combine(flavourB);
			flavourA.combine(flavourC);
			
			assertThat(captured.value, strictlyEqualTo(flavourC));
			assertThat(captured.values, array(flavourC));						
		}
		
		[Test]
		public function captureNoneShouldCaptureNoValue():void 
		{
			var captured:Capture = new Capture(CaptureType.NONE);
			
			flavourA = nice(Flavour);
			flavourB = nice(Flavour);
			flavourC = nice(Flavour);
			
			mock(flavourA).method("combine").args(capture(captured));
			
			flavourA.combine(flavourB);
			flavourA.combine(flavourB);
			flavourA.combine(flavourC);
			
			assertThat(captured.values, emptyArray());			
		}
	}
}