package mockolate.sample
{
    
    public class DarkChocolate implements Flavour
    {
        public function DarkChocolate()
        {
        }
        
        public function get name():String
        {
            return "Dark Chocolate";
        }
        
        public function get ingredients():Array
        {
            return [ "sugar", "cocoa butter", "cocoa liquor" ];
        }
        
        public function set ingredients(value:Array):void
        {
        }
        
        public function set liked(value:Boolean):void
        {
        }
        
        public function combine(flavour:Flavour, ... otherFlavours):Flavour
        {
            return this;
        }
        
        public function toString():String
        {
            return name;
        }
    
    }
}