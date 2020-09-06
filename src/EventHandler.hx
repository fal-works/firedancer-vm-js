import sinker.Maybe;
import firedancer.vm.Thread;
import firedancer.vm.PositionRef;

@:structInit
class EventHandler extends firedancer.vm.EventHandler {
	final context:FiredancerContext;

	override public function onGlobalEvent(globalEventCode:Int):Void {
		this.context.onGlobalEvent(globalEventCode);
	}

	override public function onLocalEvent(localEventCode:Int, x:Float, y:Float, thread:Thread, originPositionRef:Maybe<PositionRef>,
			targetPositionRef:PositionRef):Void {
		this.context.onLocalEvent(localEventCode, x, y, thread, originPositionRef, targetPositionRef);
	}
}
