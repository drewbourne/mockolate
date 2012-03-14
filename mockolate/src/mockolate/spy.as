package mockolate
{
	import mockolate.ingredients.MockolatierMaster;
	import mockolate.ingredients.Spy;

	/**
	 * Creates a Test Spy. 
	 * 
	 * @see mockolate.ingredients.Spy
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	var dispatcher:IEventDispatcher = nice(IEventDispatcher);
	 * 	var dispatchSpy:Spy = spy(dispatcher.dispatchEvent(arg(hasProperties({ type: Event.COMPLETE })))));
	 *
	 *	dispatcher.dispatchEvent(new Event(Event.ACTIVATE));
	 * 	dispatcher.dispatchEvent(new Event(Event.COMPLETE));
	 * 
	 * 	assertThat(dispatchSpy.called, isTrue());
	 *  assertThat(dispatchSpy.calledWith(hasProperites({ type: Event.COMPLETE })), isTrue());
	 * </listing>
	 */
	public function spy(target:*):Spy
	{
		return MockolatierMaster.mockolatier.spy(target);
	}
}