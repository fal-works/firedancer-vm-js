import sinker.Maybe;
import firedancer.vm.Program;
import firedancer.vm.PositionRef;

@:structInit
class Emitter extends firedancer.vm.Emitter {
	final context:FiredancerContext;

	override public function emit(x:Float, y:Float, vx:Float, vy:Float, fireCode:Int, program:Maybe<Program>, originPositionRef:Maybe<PositionRef>):Void {
		final ctx = this.context;
		final actor = ctx.getGroupOnFire(fireCode).use().reset(x, y, vx, vy, program.nullable(), originPositionRef.nullable());
		ctx.onFire(actor, fireCode);
	}
}
