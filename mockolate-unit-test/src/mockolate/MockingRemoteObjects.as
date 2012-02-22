package mockolate
{
	import mockolate.runner.MockolateRule;

	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.events.ResultEvent;

	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class MockingRemoteObjects
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var remoteObject:RemoteObject;

		public var service:ArbitraryItemsService;

		[Test]
		public function mocking_RemoteObjects():void 
		{
			var options:Object = { page: 1, pageSize: 3 };
			var result:Array = [ 1, 2, 3 ];

			expect(remoteObject.requestArbitraryItems(arg(options)))
				.dispatches(new ResultEvent(ResultEvent.RESULT, false, false, result));

			service = new ArbitraryItemsService(remoteObject);
			service.execute(options);

			assertThat(service.lastResult, equalTo(result));
		}
	}
}

import mx.rpc.remoting.RemoteObject;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.Fault;

internal class ArbitraryItemsService
{
	private var _remoteObject:RemoteObject;
	private var _lastResult:Array;
	private var _lastFault:Fault;

	public function ArbitraryItemsService(remoteObject:RemoteObject)
	{
		_remoteObject = remoteObject;
	}

	public function execute(options:Object):void 
	{
		_remoteObject.addEventListener(ResultEvent.RESULT, _remoteObject_result);
		_remoteObject.addEventListener(FaultEvent.FAULT, _remoteObject_fault);
		_remoteObject.requestArbitraryItems(options);
	}

	private function _remoteObject_result(event:ResultEvent):void 
	{
		_remoteObject.removeEventListener(ResultEvent.RESULT, _remoteObject_result);
		_remoteObject.removeEventListener(FaultEvent.FAULT, _remoteObject_fault);
		_lastResult = (event.result as Array);
	}

	private function _remoteObject_fault(event:FaultEvent):void 
	{
		_remoteObject.removeEventListener(ResultEvent.RESULT, _remoteObject_result);
		_remoteObject.removeEventListener(FaultEvent.FAULT, _remoteObject_fault);
		_lastFault = event.fault;
	}

	public function get lastResult():Array 
	{
		return _lastResult;
	}

	public function get lastFault():Fault 
	{
		return _lastFault;
	}
}
