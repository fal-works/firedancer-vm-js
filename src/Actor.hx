import firedancer.vm.Program;
import firedancer.vm.PositionRef;
import firedancer.vm.Vm;

@:expose("FiredancerVM.Actor")
class Actor extends firedancer.vm.Actor {
	static final emptyDraw = (actor:Actor) -> {};

	var targetPositionRef:Maybe<PositionRef>;
	var prev:Maybe<Actor>;
	var next:Maybe<Actor>;
	var group:Maybe<ActorGroup>;
	var isAlive:Bool;

	public var draw:(actor:Actor)->Void;

	public function new() {
		final threads = new firedancer.vm.ThreadList(Settings.THREAD_POOL_CAPACITY, Settings.MEMORY_CAPACITY);
		super(threads, {x: 0.0, y: 0.0});

		this.prev = Maybe.none();
		this.next = Maybe.none();
		this.group = Maybe.none();
		this.isAlive = false;
		this.targetPositionRef = Maybe.none();

		this.draw = emptyDraw;
	}

	public function setTargetPositionRef(ref:PositionRef):Void
		this.targetPositionRef = Maybe.from(ref);

	public function unsetTargetPositionRef():Void
		this.targetPositionRef = Maybe.none();

	public function update(context:FiredancerContext, eventHandler: EventHandler, emitter: Emitter):Void {
		if (!context.habitableZone.containsPoint(this.x, this.y)) {
			this.isAlive = false;
		} else {
			final ctx = context;
			final endCode = Vm.run(ctx.programPackage.programTable, eventHandler, emitter, Settings.MEMORY_CAPACITY, this,
				this.targetPositionRef.or(ctx.defaultTargetPositionRef));

			ctx.onEnd(this, endCode);
			if (endCode == -1)
				this.isAlive = false;
		}
	}

	public function synchronize():Bool {
		final position:{x:Float, y:Float} = cast this.thisPositionRef;
		if (this.isAlive) {
			position.x = this.x;
			position.y = this.y;
			return true;
		} else {
			PositionRef.invalidate(position);
			return false;
		}
	}

	public function reset(x:Float, y:Float, vx:Float, vy:Float, ?program:Program, ?originPositionRef:PositionRef, ?targetPositionRef:PositionRef):Actor {
		this.x = x;
		this.y = y;
		this.vx = vx;
		this.vy = vy;

		if (program != null)
			this.threads.set(program);
		else
			this.threads.reset();

		this.originPositionRef = Maybe.from(originPositionRef);
		this.targetPositionRef = Maybe.from(targetPositionRef);

		return this;
	}
}
