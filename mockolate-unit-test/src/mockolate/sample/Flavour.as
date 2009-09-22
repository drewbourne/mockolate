package mockolate.sample
{
    
    public interface Flavour
    {
        // read-only
        function get name():String;
        
        // read & write
        function get ingredients():Array;
        
        function set ingredients(value:Array):void;
        
        // write-only
        function set liked(value:Boolean):void;
        
        // typed & rest
        function combine(flavour:Flavour, ... otherFlavours):Flavour;
        
        // no arg
        function toString():String;
    }
}