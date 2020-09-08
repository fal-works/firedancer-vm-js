# FiredancerVM.js

A JavaScript wrapper for [Firedancer VM](https://github.com/fal-works/firedancer-vm/).


## Caveats

- Unstable!!
- Currently the thread pool capacity (the max number of threads per actor) is fixed at `8`, and the memory capacity (the memory size in bytes per actor) is fixed at `256`. Maybe these should be possible to change in future versions.


## Usage

(See also the full [Example](#Example) below)

### Load the Library

FiredancerVM.js is an IIFE library.

Load it in your HTML before loading your own script so that it defines a variable `FiredancerVM` in the global scope that can be referred from your code.

For example:

```html
<head>
  <script src="https://unpkg.com/@fal-works/firedancer-vm@0.1.2/lib/firedancer-vm.min.js" defer></script>
  <script src="path/to/your-script.js" defer></script>
</head>
```

### Prepare a `FiredancerVM.ProgramPackage` instance

Prepare any [Firedancer](https://github.com/fal-works/firedancer/) program package serialized into a JSON string representation.

Then parse it by `FiredancerVM.ProgramPackage.fromString()` so that you get a `FiredancerVM.ProgramPackage` instance, which can be executed on the VM.

### Define the Habitable Zone

Any actor that is out of the habitable zone is automatically killed.

Define the zone by either:

```ts
FiredancerVM.RectangleBounds.fromCorners(
  x1: number,
  y1: number,
  x2: number,
  y2: number
)
```

or

```ts
FiredancerVM.RectangleBounds.fromSize(
  width: number,
  height: number,
  margin: number,
  centerX: boolean = false,
  centerY: boolean = false
)
```

### Create Firedancer Context

Create a context object:

```ts
{
  programPackage: FiredancerVM.ProgramPackage,
  habitableZone: FiredancerVM.RectangleBounds,
  getGroupOnFire: (fireCode: number) => FiredancerVM.ActorGroup,
  onFire: (actor: FiredancerVM.Actor, fireCode: number) => void,
  defaultTargetPositionRef: { x: number, y: number },
  onEnd: (actor: FiredancerVM.Actor, endCode: number) => void,
  onGlobalEvent: (glotalEventCode: number) => void,
  onLocalEvent: (localEventCode: number, x: number, y: number, thread: Thread, originPositionRef: { x: number, y: number } | null, targetpositionRef: { x: number, y: number }) => void,
  defaultDraw: (actor: FiredancerVM.Actor) => void
}
```

At this moment all properties are optional, however:

- At least you'll have to eventually set `programPackage` and `getGroupOnFire` before running the VM, otherwise you'll have runtime errors. See also below about `getGroupOnFire`.
- If you don't set `defaultDraw`, you have to manually set the field `draw: (actor) => void` for each `Actor` instance in the `onFire()` function, otherwise you won't see anything on the screen.

### Create an Actor Group

Now you can create an actor group passing the context you have prepared.

```js
new FiredancerVM.ActorGroup(context);
```

### Set `context.getGroupOnFire`

The context field `getGroupOnFire` is a function that returns the actor group which should be used when any actor is fired (The argument `fireCode` receives any integer value that is specified in the original Firedancer program).

Set this function after creating your actual actor group(s).

### Activate your first Actor

Activate an actor with any program.

- You can get a Firedancer Program from your `FiredancerVM.ProgramPackage` instance by calling its method `getProgramByName(name)`.
- Call `use()` on your `FiredancerVM.ActorGroup` instance, which reserves a new actor and returns it. Then call `reset()` on the returned actor.

For example:

```js
const program = programPackage.getProgramByName("main");
const x = 0, y = 0, vx = 0, vy = 0;
actors.use().reset(x, y, vx, vy, program);
```

### Run

Call `update()` and `draw()` on your `FiredancerVM.ActorGroup` instance(s) every frame.

Basically the frame rate should be fixed at 60 FPS.


## Example

Here is a full (but simple) example using FiredancerVM.js and [p5.js](https://p5js.org/).

Be sure to load each library before your own script.

```html
<!DOCTYPE html>
<html>

<head>
  <script src="https://unpkg.com/@fal-works/firedancer-vm@0.1.2/lib/firedancer-vm.min.js" defer></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.1.9/p5.min.js" defer></script>
  <script src="path/to/your-script.js" defer></script>
</head>

<body>
</body>

</html>
```

```js
/**
 * your-script.js
 */

// Common constants
const worldWidth = 600;
const worldHeight = 600;

// Prepare your Program Package
const programPackage = FiredancerVM.ProgramPackage.fromString(`{
  "nameIdMap": {
    "main": 0
  },
  "programTable": [
    "s44:4AAAAAAAAAAAAAAAAAAAFEAj%Nbre:Ppzso:AAIRAAAA"
  ],
  "vmVersion": "0.1.0"
}`);

// Define the Habitable Zone of your actors
const margin = 60;
const centerX = true;
const centerY = true;
const habitableZone = FiredancerVM.RectangleBounds.fromSize(
  worldWidth,
  worldHeight,
  margin,
  centerX,
  centerY
);

// Create Context
const context = {
  programPackage,
  habitableZone,
};

// Create Actor Group
const actors = new FiredancerVM.ActorGroup(context);

// Set the Actor Group used when fired
context.getGroupOnFire = () => actors;

// Setup (p5.js)
function setup() {
  createCanvas(worldWidth, worldHeight);

  // Drawing settings
  stroke("#4d089a");
  fill("#4d089a20");
  context.defaultDraw = (actor) => circle(actor.x, actor.y, 30);

  // Your first actor.
  // Call actors.clear() if you'd like to remove all the existing actors
  const x = 0, y = 0, vx = 0, vy = 0;
  actors.use().reset(x, y, vx, vy, programPackage.getProgramByName("main"));
}

// Draw (p5.js)
function draw() {
  // Update your actor group(s)
  actors.update();

  // Draw your actor group(s)
  background(252);
  translate(width / 2, height / 2);
  actors.draw();
}
```

## Third Party Licenses

The following software may be included in this product:

### The Haxe Standard Library

© 2005-2016 Haxe Foundation

Used under [MIT License](https://haxe.org/foundation/open-source.html).
