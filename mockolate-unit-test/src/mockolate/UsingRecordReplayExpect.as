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
			expect(flavour.combine(other)).returns(result);
			
			assertThat(flavour.combine(other), equalTo(result));
		}
		
		[Test]
		public function expectMethodWithMatchers():void 
		{
			expect(flavour.combine(arg(isA(Flavour)))).returns(result);
			
			assertThat(flavour.combine(other), equalTo(result));
		}
		
		[Test]
		public function expectGetter():void 
		{
			expect(flavour.name).returns("butterscotch");
			
			assertThat(flavour.name, equalTo("butterscotch"));
		}
		
		[Test]
		public function expectSetter():void 
		{
			expect(flavour.liked = true);
			
			flavour.liked = true;
		}
		
		[Test]
		public function expectSetterWithMatcher():void 
		{
			expect(flavour.liked = arg(isA(Boolean)));
			
			flavour.liked = true;
		}
		
		[Test]
		public function expectAllInOne():void 
		{
			expect(flavour.name).returns("butterscotch");
			expect(flavour.liked = arg(isA(Boolean)));
			expect(flavour.combine(other)).returns(result);
			
			flavour.liked = true;
			assertThat(flavour.name, equalTo("butterscotch"));
			assertThat(flavour.combine(other), equalTo(result));
		}
	}
}