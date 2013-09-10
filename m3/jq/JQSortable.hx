package m3.jq;

import m3.jq.JQ;
// import embi.mdjq.JQ.UIPosition;

typedef UISortable = {
	helper: JQ, 
	item: JQ,
	sender: JQ,
	position: UIPosition, 
	offset: UIPosition,
	originalPosition: UIPosition
}

typedef JQSortableOpts = {
	
	@:optional var axis: String; // "x|y"
	@:optional var connectWith: Dynamic; //"input;textarea;button;select;option"
	@:optional var cancel: Dynamic; //"input;textarea;button;select;option"
	@:optional var cancelAll: Bool;
	@:optional var items: Dynamic; //"input;textarea;button;select;option"
	@:optional var maxChildren: Int;
	
	// callbacks
	@:optional var receive: JQEvent->UISortable->Void;
	@:optional var remove: JQEvent->UISortable->Void;
	@:optional var stop: JQEvent->UISortable->Void;
}

@:native("$")
extern class JQSortable extends JQ {
	function disableSelection():Void;

	@:overload(function(cmd: String):Bool{})
	@:overload(function(cmd: String, opt:String):Dynamic{})
	@:overload(function(cmd: String, opt:String, newVal:Dynamic):JQSortable{})
	function sortable(?opts: JQSortableOpts): JQSortable;
}