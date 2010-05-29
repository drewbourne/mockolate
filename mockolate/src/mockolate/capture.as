package mockolate
{
	import mockolate.ingredients.Capture;
	import mockolate.ingredients.CaptureMatcher;

	public function capture(capture:Capture):CaptureMatcher
	{
		return new CaptureMatcher(capture);
	}
}