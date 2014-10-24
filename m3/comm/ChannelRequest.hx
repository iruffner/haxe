package m3.comm;

class ChannelRequest {}

@:rtti
class ChannelRequestMessage {
	private var path:String;
	private var context:Dynamic;
	private var parms:Dynamic;

	public function new(path:String, context:{context: String, handle: String}, parms:Dynamic):Void {
		this.path    = path;
		this.context = context;
		this.parms   = parms;
	}
}

@:rtti
class ChannelRequestMessageBundle {

	private var channel:String;
	private var requests:Array<ChannelRequestMessage>;

    public function new(channel:String, requests:Array<ChannelRequestMessage>) {
        this.channel = channel;
        this.requests = requests;
    }

	public function add(request:ChannelRequestMessage):Void {
		this.requests.push(request);
	}

	public function createAndAdd(path:String, context:{context: String, handle: String}, parms:Dynamic):Void {
		var request = new ChannelRequestMessage(path, context, parms);
		this.add(request);
	}
}
