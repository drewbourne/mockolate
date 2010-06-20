package mockolate
{
	import mockolate.runner.MockolateRule;
	import mockolate.sample.Flavour;
	
	import org.flexunit.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class UsingRecordReplayExpect
	{
		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();
		
		[Mock]
		public var flavour:Flavour;
		
		[Mock]
		public var other:Flavour;
		
		[Mock]
		public var result:Flavour;
		
		[Test]
		public function expectMethod():void 
		{
			record(flavour);
			expect(flavour.combine(other)).returns(result);
			replay(flavour);
			
			assertThat(flavour.combine(other), equalTo(result));
		}
		
		[Test]
		public function expectMethodWithMatchers():void 
		{
			record(flavour);
			expect(flavour.combine(expectArg(isA(Flavour)))).returns(result);
			replay(flavour);
			
			assertThat(flavour.combine(other), equalTo(result));
		}
		
		[Test]
		public function expectGetter():void 
		{
			record(flavour);
			expect(flavour.name).returns("butterscotch");
			replay(flavour);
			
			assertThat(flavour.name, equalTo("butterscotch"));
		}
		
		[Test]
		public function expectSetter():void 
		{
			record(flavour);
			expect(flavour.liked = true);
			replay(flavour);
			
			flavour.liked = true;
		}
		
		[Test]
		public function expectSetterWithMatcher():void 
		{
			record(flavour);
			expect(flavour.liked = expectArg(isA(Boolean)));
			replay(flavour);
			
			flavour.liked = true;
		}
		
		[Test]
		public function expectAllInOne():void 
		{
			record(flavour);
			expect(flavour.name).returns("butterscotch");
			expect(flavour.liked = expectArg(isA(Boolean)));
			expect(flavour.combine(other)).returns(result);
			replay(flavour);
			
			flavour.liked = true;
			assertThat(flavour.name, equalTo("butterscotch"));
			assertThat(flavour.combine(other), equalTo(result));
		}
	}
}