'use strict';

const programPackage = FiredancerVM.ProgramPackage.fromString(`{
  "nameIdMap": {
    "main": 0
  },
  "programTable": [
    "s44:4AAAAAAAAAAAAAAAAAAAFEAj%Nbre:Ppzso:AAIRAAAA"
  ],
  "vmVersion": "0.1.0"
}`);

const habitableZone = FiredancerVM.RectangleBounds.fromSize(600, 600, 60, true, true);

const context = {
  programPackage,
  habitableZone,
};

const actors = new FiredancerVM.ActorGroup(context);

context.getGroupOnFire = () => actors;

function setup() {
  createCanvas(600, 600);

  context.defaultDraw = (actor) => {
    circle(actor.x, actor.y, 10);
  };

  actors.clear();
  actors.use().reset(0, 0, 0, 0, programPackage.getProgramByName("main"));
}

function draw() {
  background(252);

  actors.update();

  translate(width / 2, height / 2);
  actors.draw();
}
