package mockolate.ingredients
{
    
    public class InvocationType
    {
        public static const METHOD:InvocationType = new InvocationType("METHOD");
        
        public static const GETTER:InvocationType = new InvocationType("GETTER");
        
        public static const SETTER:InvocationType = new InvocationType("SETTER");
        
        private var _name:String;
        
        public function InvocationType(name:String)
        {
            _name = name;
        }
        
        public function get isMethod():Boolean
        {
            return this == METHOD;
        }
        
        public function get isGetter():Boolean
        {
            return this == GETTER;
        }
        
        public function get isSetter():Boolean
        {
            return this == SETTER;
        }
        
        public function toString():String
        {
            return _name;
        }
    }
}