package m3.event;
import haxe.ds.StringMap;
import m3.util.UidGenerator;
import m3.log.Logga;

using m3.helper.ArrayHelper;

class EventManager {
	private var hash: StringMap<Map<String,EMListener>>;
	private var oneTimers: Array<String>;

	@:isVar public static var instance(get,null): EventManager;
    private static function get_instance(): EventManager {
        if (instance == null) {
            instance = new EventManager();
        }
        return instance;
    }

	private function new(): Void {
		this.hash = new StringMap<Map<String,EMListener>>();
		this.oneTimers = new Array<String>();
	}

	public function on<T>(id: String, func: T->Void, ?listenerName:String): String {
		return addListener(id, func, listenerName);
	}

	public function addListener<T>(id: String, func: T->Void, ?listenerName:String): String {
		var listener = new EMListener(func, listenerName);
		return addListenerInternal(id, listener);
	}

	private function addListenerInternal<T>(id: String, listener: EMListener): String {
		var map: Map<String, EMListener> = hash.get(id);
		if(map == null) {
			map = new Map<String, EMListener>();
			hash.set(id, map);
		}
		map.set(listener.uid, listener);
		return listener.uid;
	}

	public function listenOnce<T>(id: String, func: T->Void, ?listenerName:String): String {
		var listener = new EMListener(func, listenerName);
		oneTimers.push(listener.uid);
		return addListenerInternal(id, listener);
	}

	public function removeListener<T>(id: String, listenerUid: String):Void {
		var map: Map<String, EMListener> = hash.get(id);
		if(map == null) {
			Logga.DEFAULT.warn("removeListener called for unknown uuid");
		} else {
			oneTimers.remove(listenerUid);
			map.remove(listenerUid);
		}
	}

	public function fire<T>(id: String, ?t: T): Void {
		change(id, t);
	}

	public function change<T>(id: String, ?t: T): Void {
		var logger = Logga.DEFAULT;

		logger.debug("EVENTMODEL: Change to " + id);
		var map: Map<String, EMListener> = hash.get(id);
		if(map == null) {
			logger.warn("No listeners for event " + id);
			return;
		}
		var iter: Iterator<EMListener> = map.iterator();
		while(iter.hasNext()) {
			var listener: EMListener = iter.next();
			logger.debug("Notifying " + listener.name + " of " + id + " event");
			try {
				listener.change(t);
				if(oneTimers.remove(listener.uid)) {
					map.remove(listener.uid);
				}
			} catch(err: Dynamic) {
				logger.error("Error executing " + listener.name + " of " + id + " event", Logga.getExceptionInst(err));
			}
		}
	}
}


class EMListener {
	var fcn: Dynamic;
	@:isVar public var uid(get,null): String;
	@:isVar public var name(get,null): String;

	public function new<T>(fcn: T->Void, ?name: String) {
		this.fcn = fcn;
		this.uid = UidGenerator.create(20);
		this.name = name == null ? uid : name;
	}

	public function change<T>(t: T): Void {
		this.fcn(t);
	}
	function get_uid(): String {
		return this.uid;
	}
	function get_name(): String {
		return this.name;
	}
}
