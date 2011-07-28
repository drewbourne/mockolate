package mockolate
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    
    import org.flexunit.assertThat;
    import org.flexunit.async.Async;
    import org.hamcrest.core.not;
    import org.hamcrest.object.isFalse;
    import org.hamcrest.object.isTrue;
    import org.hamcrest.object.nullValue;
    
    public class UsingFlashClasses
    {        
        [Test(async, timeout=10000)]
        public function prepareMovieClip():void 
        {
            Async.handleEvent(this, 
                prepare(Sprite), 
                Event.COMPLETE, prepareComplete, 10000); 
        }
        
        public function prepareComplete(event:Event, data:Object):void 
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