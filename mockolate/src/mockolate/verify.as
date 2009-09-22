package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    import mockolate.ingredients.VerifyingCouverture;
    
    public function verify(target:*, propertyOrMethod:String=null):VerifyingCouverture
    {
        return MockolatierMaster.verify(target, propertyOrMethod);
    }
}
