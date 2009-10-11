package mockolate.mistakes
{
    import mockolate.ingredients.Mockolate;
    
    public class VerifyFailedError extends MockolateError
    {
        public function VerifyFailedError(message:String, mockolate:Mockolate=null, target:Object=null)
        {
            super("Verify Failed " + message, mockolate, target);
        }
    }
}
