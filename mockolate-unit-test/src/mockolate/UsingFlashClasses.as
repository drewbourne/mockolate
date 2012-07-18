package mockolate
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    import mockolate.runner.MockolateRule;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.not;
    import org.hamcrest.object.isFalse;
    import org.hamcrest.object.isTrue;
    import org.hamcrest.object.nullValue;
    
    public class UsingFlashClasses
    {        
        [Rule]
        public var mocks:MockolateRule = new MockolateRule();

        [Mock(inject="false")]
        public var sprite:Sprite;
        
        [Test]
        public function sprite_should_be_proxiable():void 
        {
            var sprite:Sprite = nice(Sprite);
            assertThat(sprite, not(nullValue()));
            
            mock(sprite).method('willTrigger').args(Event.COMPLETE).returns(true);
            mock(sprite).method('willTrigger').args(Event.CANCEL).returns(false);
            
            assertThat(sprite.willTrigger(Event.COMPLETE), isTrue());
            assertThat(sprite.willTrigger(Event.CANCEL), isFalse());
            
            verify(sprite);
        }
    }
}