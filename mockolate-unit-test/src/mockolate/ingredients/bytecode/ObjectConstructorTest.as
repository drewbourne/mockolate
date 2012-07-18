package mockolate.ingredients.bytecode
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;

	public class ObjectConstructorTest
	{
		[Test]
		public function object_():void 
		{
			trace("\n\n\n");

			var none:NoConstructor = new NoConstructor();
			trace("NoConstructor")
			trace("\t .hasOwnProperty()", none.hasOwnProperty("constructor"));
			// === false

			var over:OverridesConstructor = new OverridesConstructor();
			trace("OverridesConstructor")
			trace("\t .hasOwnProperty()", over.hasOwnProperty("constructor"));
			// === true

			trace("\n\n\n");
		}
	}
}

internal class NoConstructor 
{
}

internal class OverridesConstructor 
{
	public function get constructor():Object 
	{
		return null;
	}
}