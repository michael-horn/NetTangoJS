
class Model {
   
   var turtles;
   bool loaded = false;
   var name = "";

   NetTango ntango;
   
   int patchSize = 50;
   int maxPatchX = 12;
   int minPatchX = -12;
   int maxPatchY = 12;
   int minPatchY = -12;
   
   
   Model(this.ntango) {
      turtles = [];
      for (int i=0; i<60; i++) {
         Turtle t = new Turtle(i, this);
         turtles.add(t);
         ntango.addTouchable(t);
      }
   }
   
   
   void resizeToFitScreen(int screenW, int screenH) {
      int hpatches = screenW ~/ patchSize;
      int vpatches = screenH ~/ patchSize;
      maxPatchX = hpatches ~/ 2;
      maxPatchY = vpatches ~/ 2;
      minPatchX = maxPatchX - hpatches + 1;
      minPatchY = maxPatchY - vpatches + 1;
   }
   
   
   void restart() { }
   
   void tick(int count) {
      for (var turtle in turtles) {
         turtle.animate();
      }      
   }
 
   
   void draw(var ctx) {
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