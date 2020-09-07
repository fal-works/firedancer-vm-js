import firedancer.vm.ProgramPackage;
import firedancer.vm.PositionRef;
import firedancer.vm.Thread;

typedef FiredancerContext = {
	programPackage:ProgramPackage,
	defaultTargetPositionRef:PositionRef,
	onEnd:(actor:Actor, endCode:Int) -> Void,
	habitableZone:RectangleBounds,
	getGroupOnFire:(fireCode:Int) -> ActorGroup,
	onFire:(actor:Actor, fireCode:Int) -> Void,
	onGlobalEvent:(glotalEventCode:Int) -> Void,
	onLocalEvent:(localEventCode:Int, x:Float, y:Float, thread:Thread, originPositionRef:Maybe<PositionRef>, targetpositionRef:PositionRef) -> Void,
	defaultDraw:(actor:Actor) -> Void
};

class FiredancerContextTools {
	static inline function isNone(v:Dynamic):Bool {
		#if js
		return js.Syntax.code("{0} == null || {0} == undefined", v);
		#else
		return v == null;
		#end
	}

	public static function fill(ctx:FiredancerContext):FiredancerContext {
		if (isNone(ctx.programPackage))
			throw "Missing property \"programPackage\" in the context.";
		if (isNone(ctx.defaultTargetPositionRef))
			ctx.defaultTargetPositionRef = {x: 0.0, y: 0.0};
		if (isNone(ctx.onEnd))
			ctx.onEnd = (_, _) -> {};
		if (isNone(ctx.habitableZone))
			ctx.habitableZone = RectangleBounds.fromSize(640.0, 480.0, 0.0, true, true);
		if (isNone(ctx.getGroupOnFire))
			ctx.getGroupOnFire = (_) -> throw "Missing getGroupOnFire() in the current context.";
		if (isNone(ctx.onFire))
			ctx.onFire = (_, _) -> {};
		if (isNone(ctx.onGlobalEvent))
			ctx.onGlobalEvent = (_) -> {};
		if (isNone(ctx.onLocalEvent))
			ctx.onLocalEvent = (_, _, _, _, _, _) -> {};
		if (isNone(ctx.defaultDraw))
			ctx.defaultDraw = (_) -> {};

		return ctx;
	}
}
