/*
 * NetTango
 *
 * Michael S. Horn
 * Northwestern University
 * michael-horn@northwestern.edu
 * Copyright 2012, Michael S. Horn
 *
 * This project was funded in part by the National Science Foundation.
 * Any opinions, findings and conclusions or recommendations expressed in this
 * material are those of the author(s) and do not necessarily reflect the views
 * of the National Science Foundation (NSF).
 */
class Model {
   
   // A collection of turtles in the model
   List turtles;
   
   // A list of patches
   List patches;

   // Reference to the main application
   NetTango ntango;
   
   // Size of a patch in pixels
   int patchSize = 50;
   
   // Dimensions of the world in patch coordinates
   int maxPatchX = 12;
   int minPatchX = -12;
   int maxPatchY = 12;
   int minPatchY = -12;
   
   
   Model(this.ntango) {
      turtles = new List<Turtle>();
      patches = new List<Patch>();
      
      for (int i=0; i<60; i++) {
         Turtle t = new Turtle(i, this);
         turtles.add(t);
         ntango.addTouchable(t);
      }
      
      // don't create patches until resize is called
   }
   
   
   void resizeToFitScreen(int screenW, int screenH) {
      int hpatches = screenW ~/ patchSize;
      int vpatches = screenH ~/ patchSize;
      maxPatchX = hpatches ~/ 2;
      maxPatchY = vpatches ~/ 2;
      minPatchX = maxPatchX - hpatches + 1;
      minPatchY = maxPatchY - vpatches + 1;
      
      for (int i=minPatchX; i<=maxPatchX; i++) {
         for (int j=minPatchY; j<=maxPatchY; j++) {
            patches.add(new Patch(i, j));
         }
      }
   }
   
   
   void restart() { }
   
   
   void tick(int count) {
      for (var turtle in turtles) {
         turtle.animate();
      }
      
      for (var patch in patches) {
         patch.animate();
      }
   }
 
   
   void drawTurtles(var ctx) {
      num cx = (0.5 - minPatchX) * patchSize;
      num cy = (0.5 - minPatchY) * patchSize;
      ctx.save();
      ctx.translate(cx, cy);
      ctx.scale(patchSize, -patchSize);
      
      for (var turtle in turtles) {
         turtle.draw(ctx);
      }
      ctx.restore();
   }
   
   
   void drawPatches(var ctx) {
      num cx = (0.5 - minPatchX) * patchSize;
      num cy = (0.5 - minPatchY) * patchSize;
      ctx.save();
      ctx.translate(cx, cy);
      ctx.scale(patchSize, -patchSize);
      for (var patch in patches) {
         patch.draw(ctx);
      }
      ctx.restore();
   }
   
   
   num screenToWorldX(num sx, num sy) {
      num cx = (0.5 - minPatchX) * patchSize;
      return (sx - cx) / patchSize;
   }
   
   
   num screenToWorldY(num sx, num sy) {
      num cy = (0.5 - minPatchY) * patchSize;
      return (cy - sy) / patchSize;      
   }
   
   
   num get minWorldY => minPatchY - 0.5;
   num get minWorldX => minPatchX - 0.5;
   num get maxWorldY => maxPatchY + 0.5;
   num get maxWorldX => maxPatchX + 0.5;
   int get worldWidth => maxPatchX - minPatchX + 1;
   int get worldHeight => maxPatchY - minPatchY + 1;
   
}