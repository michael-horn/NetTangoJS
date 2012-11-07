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
   int patchSize = 40;
   
   // Dimensions of the world in patch coordinates
   int maxPatchX = 12;
   int minPatchX = -12;
   int maxPatchY = 12;
   int minPatchY = -12;
   
   // Used to generate unique turtle id numbers
   int TURTLE_ID = 0;
   
   
   Model(this.ntango) {
      turtles = new List<Turtle>();
      patches = null; // don't create patches until resize is called
   }
   
   
   void setup() {
      turtles = new List<Turtle>();
      var colors = [
                   new Color(255, 0, 0, 255),
                   new Color(0, 255, 0, 255),
                   new Color(0, 0, 255, 255),
                   new Color(255, 255, 0, 255),
                   new Color(0, 255, 255, 255)];
     
      for (int i=0; i<60; i++) {
         Turtle t = new Turtle(this);
         t.color = colors[i % 5].clone();
         addTurtle(t);
      }
   }     
   
   
   void addTurtle(Turtle t) {
      turtles.add(t);
      TouchManager.addTouchable(t);
   }
   
   
   void resizeToFitScreen(int screenW, int screenH) {
      int hpatches = screenW ~/ patchSize;
      int vpatches = screenH ~/ patchSize;
      maxPatchX = hpatches ~/ 2;
      maxPatchY = vpatches ~/ 2;
      minPatchX = maxPatchX - hpatches + 1;
      minPatchY = maxPatchY - vpatches + 1;
      
      patches = new List(hpatches);
      for (int i=0; i < hpatches; i++) {
         patches[i] = new List<Patch>(vpatches);
         for (int j=0; j < vpatches; j++) {
            patches[i][j] = new Patch(this, i + minPatchX, j + minPatchY);
            TouchManager.addTouchable(patches[i][j]);
         }
      }
   }
   
      
   void tick(int count) {
     
      // remove dead turtles
      for (int i=turtles.length - 1; i >= 0; i--) {
         Turtle t = turtles[i];
         if (t.dead) {
            turtles.removeAt(i);
            TouchManager.removeTouchable(t);
         }
      }
      
      // animate turtles
      for (var turtle in turtles) {
         turtle.animate();
      }
      
      // animate patches
      if (patches != null) {
         for (var col in patches) {
            for (var patch in col) {
               patch.animate();
            }
         }
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
      if (patches == null) return;
      num cx = (0.5 - minPatchX) * patchSize;
      num cy = (0.5 - minPatchY) * patchSize;
      ctx.save();
      ctx.translate(cx, cy);
      ctx.scale(patchSize, -patchSize);
      for (var col in patches) {
         for (var patch in col) {
            patch.draw(ctx);
         }
      }
      ctx.restore();
   }
   
   
   Patch patchAt(num tx, num ty) {
      if (patches == null) {
         return null;
      } else {
         int i = tx.round().toInt() - minPatchX;
         int j = ty.round().toInt() - minPatchY;
         return patches[i][j];
      }
   }
   
   
   num screenToWorldX(num sx, num sy) {
      num cx = (0.5 - minPatchX) * patchSize;
      return (sx - cx) / patchSize;
   }
   
   
   num screenToWorldY(num sx, num sy) {
      num cy = (0.5 - minPatchY) * patchSize;
      return (cy - sy) / patchSize;      
   }
   
   
   int get nextTurtleId => TURTLE_ID++;
   num get minWorldY => minPatchY - 0.5;
   num get minWorldX => minPatchX - 0.5;
   num get maxWorldY => maxPatchY + 0.5;
   num get maxWorldX => maxPatchX + 0.5;
   int get worldWidth => maxPatchX - minPatchX + 1;
   int get worldHeight => maxPatchY - minPatchY + 1;
   
}