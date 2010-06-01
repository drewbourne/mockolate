package mockolate.runner
{
	import asx.array.compact;
	import asx.array.map;
	import asx.array.mapSequentially;
	import asx.array.pluck;
	import asx.array.unique;
	import asx.fn.callFunction;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	
	import mockolate.errors.MockolateError;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.runner.statements.IdentifyMockClasses;
	import mockolate.runner.statements.InjectMockInstances;
	import mockolate.runner.statements.PrepareMockClasses;
	import mockolate.runner.statements.VerifyMockInstances;
	import mockolate.strict;
	import mockolate.verify;
	
	import org.flexunit.internals.runners.InitializationError;
	import org.flexunit.internals.runners.statements.IAsyncStatement;
	import org.flexunit.internals.runners.statements.MethodRuleBase;
	import org.flexunit.internals.runners.statements.StatementSequencer;
	import org.flexunit.rules.IMethodRule;
	import org.flexunit.runners.model.FrameworkMethod;
	import org.flexunit.token.AsyncTestToken;
	import org.flexunit.token.ChildResult;
	
	public class MockolateRule extends MethodRuleBase implements IMethodRule
	{
		protected var sequence:StatementSequencer;
		protected var data:MockolateRunnerData;
		
		public function MockolateRule()
		{
			super();
		}
		
		override public function apply(base:IAsyncStatement, method:FrameworkMethod, test:Object):IAsyncStatement
		{
			super.apply(base, method, test);
			
			this.data = new MockolateRunnerData();
			this.data.test = test;
			this.data.method = method;
			
			sequence = new StatementSequencer();
			sequence.addStep(new IdentifyMockClasses(data));
			sequence.addStep(new PrepareMockClasses(data));
			sequence.addStep(new InjectMockInstances(data));
			sequence.addStep(base);
			sequence.addStep(new VerifyMockInstances(data));
						
			return this;
		}
		
		override public function evaluate(parentToken:AsyncTestToken):void 
		{
			super.evaluate(parentToken);
			
			sequence.evaluate(myToken);
		}
		
		override public function toString():String
		{
			return "MockolateRule";
		}
	}
}
