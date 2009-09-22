package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    import mockolate.ingredients.StubbingCouverture;
    
    public function stub(target:*, propertyOrMethod:String):StubbingCouverture
    {
        return MockolatierMaster.stub(target, propertyOrMethod);
    }
}
