package m3.jq;

import m3.jq.JQ;

using m3.helper.StringHelper;

class ButtonSetV extends JQ{
	public function buttonsetv(element: Dynamic, defaultMaxWidth: Int, arg2: String) {
        if(arg2 == "refresh") {
            new JQ('label', this).removeClass('ui-corner-bottom').removeClass('ui-corner-top');
            new JQ(this).buttonset("refresh");
        } else {
//            $(':radio, :checkbox', this).wrap('<div style="margin: 1px"/>');
            new JQ(this).buttonset();
        } 
        new JQ('label:first', this).removeClass('ui-corner-left').addClass('ui-corner-top');
        new JQ('label:last', this).removeClass('ui-corner-right').addClass('ui-corner-bottom');
        new JQ('label:visible', this).filter(":first").addClass('ui-corner-top').end().filter(":last").addClass("ui-corner-bottom");
        var mw = defaultMaxWidth; // max width
        new JQ('label', this).each(function(index){
            var w = new JQ(this).width();
            if (w > mw) mw = w; 
        });
        new JQ('label', this).each(function(index){
            $(this).width(mw);
        });
	}
}