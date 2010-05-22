package mockolate.ingredients
{
	import org.hamcrest.Matcher;
	import org.hamcrest.core.anyOf;
	import org.hamcrest.date.dateEqual;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.text.re;

	/**
	 * Converts a value to a Matcher for use when matching Invocation arguments. 
	 *  
	 * @private
	 */
	internal function valueToMatcher(value:*):Matcher
	{
		// when the value is RegExp
		// then match either a reference to the given RegExp
		// or create a Matcher for that RegExp
		//
		if (value is RegExp)
		{
			return anyOf(equalTo(value), re(value as RegExp));
		}
		
		// when the value is a Date
		// then match the Date by reference
		// or match the Date using dateEqual()
		//
		if (value is Date)
		{
			return anyOf(equalTo(value), dateEqual(value));
		}
		
		// when explicitly given a Class
		// then match either the Class reference or an instance of that Class.
		// 
		// eg: mock(instance).property("enabled").arg(Boolean);
		//
		// if the test should be more exact then the user must supply a value
		// or matcher instance instead.
		// 
		if (value is Class)
		{
			return anyOf(equalTo(value), instanceOf(value))
		}
		
		// when the value is a Matcher
		// then leave it as is.
		//
		if (value is Matcher)
		{
			return value as Matcher;
		}
		
		// otherwise match by ==
		//
		return equalTo(value);
	}
}