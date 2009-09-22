package mockolate.ingredients
{
    import org.flexunit.assertThat;
    
    public class VerifyingCouvertureTest
    {
        
        [Test]
        public function shouldFailAsUntested():void
        {
            assertThat("not tested", false);
        }
    }
}