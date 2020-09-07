import FiredancerContext;

@:expose("FiredancerVM.ActorGroup")
@:access(Actor)
class ActorGroup {
	final actorPool:Array<Actor>;
	final reservedActors:Array<Actor>;
	final context:FiredancerContext;
	final eventHandler: EventHandler;
	final emitter:Emitter;
	var first:Maybe<Actor>;
	var last:Maybe<Actor>;

	public function new(context:FiredancerContext) {
		this.actorPool = [];
		this.reservedActors = [];

		this.context = FiredancerContextTools.fill(context);
		this.eventHandler = { context: context };
		this.emitter = { context: context };

		this.first = Maybe.none();
		this.last = Maybe.none();
	}

	/**
		Updates all actors and then add new reserved actors.
	**/
	public function update():Void {
		this.updateActors();
		this.addReservedActors();
	}

	/**
		Draws all actors.
	**/
	public function draw():Void {
		var cur = this.first;
		while (cur.isSome()) {
			final actor = cur.unwrap();

			if (!actor.synchronize()) {
				this.remove(actor);
				this.actorPool.push(actor);
			}

			actor.draw(actor);
			cur = actor.next;
		}
	}

	/**
		Finds a new available actor (if not found, creates a new one) and reserves it to be activated.
		Be sure to call `reset()` on the returned `Actor`.
	**/
	public function use():Actor {
		final actorPool = this.actorPool;
		final actor = if (!actorPool.length.isZero()) actorPool.pop().unwrap() else new Actor();

		this.reservedActors.push(actor);
		actor.draw = this.context.defaultDraw;

		return actor;
	}

	function updateActors():Void {
		final context = this.context;
		final eventHandler = this.eventHandler;
		final emitter = this.emitter;

		var cur = this.first;
		while (cur.isSome()) {
			final actor = cur.unwrap();
			actor.update(context, eventHandler, emitter);
			cur = actor.next;
		}
	}

	function addReservedActors():Void {
		final reservedActors = this.reservedActors;
		for (i in 0...reservedActors.length) {
			final actor = reservedActors[i];
			actor.isAlive = true;
			this.add(actor);
		}

		reservedActors.resize(0);
	}

	function add(actor:Actor):Void {
		actor.group = Maybe.from(this);

		if (this.first.isNone()) {
			this.first = this.last = Maybe.from(actor);
			actor.prev = actor.next = Maybe.none();
		} else {
			this.last.unwrap().next = Maybe.from(actor);
			actor.prev = this.last;
			actor.next = Maybe.none();
			this.last = Maybe.from(actor);
		}
	}

	function remove(actor:Actor) {
		if (actor.prev.isNone()) {
			if (this.first == actor)
				this.first = actor.next;
		} else {
			actor.prev.unwrap().next = actor.next;
		}

		if (actor.next.isNone()) {
			if (this.last == actor)
				this.last = actor.prev;
		} else {
			actor.next.unwrap().prev = actor.prev;
		}

		actor.group = Maybe.none();
	}
}
