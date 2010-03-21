package mockolate
{
    import flash.display.MovieClip;
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
                prepare(MovieClip), 
                Event.COMPLETE, prepareComplete, 10000); 
        }
        
        public function prepareComplete(event:Event, data:Object):void 
        {
            var movieClip:MovieClip = nice(MovieClip);
            assertThat(movieClip, not(nullValue()));
            
            mock(movieClip).method('willTrigger').args(Event.COMPLETE).returns(true);
            mock(movieClip).method('willTrigger').args(Event.CANCEL).returns(false);
            
            assertThat(movieClip.willTrigger(Event.COMPLETE), isTrue());
            assertThat(movieClip.willTrigger(Event.CANCEL), isFalse());
            
            verify(movieClip);
        }
    }
}