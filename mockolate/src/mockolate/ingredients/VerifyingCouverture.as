package mockolate.ingredients
{
    use namespace mockolate_ingredient;
    
    /**
     * Verify as a Test Spy
     */
    public class VerifyingCouverture extends RecordingCouverture
    {
        public function VerifyingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
        }
        
        public function method(name:String, ns:String=null):VerifyingCouverture
        {
            return this;
        }
        
        public function property(name:String, ns:String=null):VerifyingCouverture
        {
            return this;
        }
        
        public function args(... rest):VerifyingCouverture
        {
            return this;
        }
        
        public function times(n:int):VerifyingCouverture
        {
            return this;
        }
        
        public function never():VerifyingCouverture
        {
            return times(0);
        }
        
        public function once():VerifyingCouverture
        {
            return times(1);
        }
        
        public function twice():VerifyingCouverture
        {
            return times(2);
        }
        
        // at the behest of Brian LeGros we have thrice()
        public function thrice():VerifyingCouverture
        {
            return times(3);
        }
        
        public function atLeast(n:int):VerifyingCouverture
        {
            return this;
        }
        
        public function atMost(n:int):VerifyingCouverture
        {
            return this;
        }
        
        public function ordered(group:String=null):VerifyingCouverture
        {
            return this;
        }
        
        /**
         *
         */
        override mockolate_ingredient function verify():void
        {
        
        }
    }
}
