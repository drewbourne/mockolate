package mockolate
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    import mockolate.ingredients.MockolatierMaster;
    
    public function prepare(... rest):IEventDispatcher
    {
        return MockolatierMaster.prepare(rest);
    }
}
