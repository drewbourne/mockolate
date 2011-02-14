package mockolate.ingredients
{
    import org.flexunit.assertThat;
    import org.hamcrest.object.sameInstance;
    
    public class CouvertureTest
    {
        private var mockolate:Mockolate;
        private var couverture:Couverture;
        
        [Test(expected="ArgumentError")]
        public function constructorShouldComplainIfNotGivenMockolate():void
        {
            couverture = new Couverture(null);
        }
        
        [Test]
        public function shouldHaveMockolate():void
        {
            mockolate = new Mockolate();
            couverture = new Couverture(mockolate);
            assertThat(couverture.mockolateInstance, sameInstance(mockolate));
        }
    }
}
