'use strict';

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
