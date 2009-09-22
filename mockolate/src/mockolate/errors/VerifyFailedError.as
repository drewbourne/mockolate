package mockolate.errors
{
    import mockolate.ingredients.Mockolate;
    
    public class VerifyFailedError extends MockolateError
    {
        public function VerifyFailedError(mockolate:Mockolate, target:Object)
        {
            super("Verify Failed", mockolate, target);
        }
    }
}
