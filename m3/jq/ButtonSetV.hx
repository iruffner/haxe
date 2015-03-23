package m3.jq;

import m3.jq.JQ;
import js.html.Element;

@:native("$.fn")
extern class ButtonSetV{
    public static function buttonsetv(self: JQ, defaultMaxWidth: Int, ?arg2: String): JQ;

    private static function __init__(): Void {
        JQ.fn.buttonsetv = function(self: JQ, defaultMaxWidth: Int, ?arg2: String): JQ {
            if(arg2 == "refresh") {
                new JQ('label', self).removeClass('ui-corner-bottom').removeClass('ui-corner-top');
                self.buttonset("refresh");
            } else {
                self.buttonset();
            } 
            new JQ('label:first', self).removeClass('ui-corner-left').addClass('ui-corner-top');
            new JQ('label:last', self).removeClass('ui-corner-right').addClass('ui-corner-bottom');
            new JQ('label:visible', self).filter(":first").addClass('ui-corner-top').end().filter(":last").addClass("ui-corner-bottom");
            var mw = defaultMaxWidth; // max width
            new JQ('label', self).each(function(){
                var w = JQ.cur.width();
                if (w > mw) mw = w; 
            });
            new JQ('label', self).each(function(){
                JQ.cur.width(mw);
            });      
            return self;              
        }
    }
}
