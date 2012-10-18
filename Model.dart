
class Model {
   
   var turtles;
   bool loaded = false;
   var name = "";
   num w = 700;
   num h = 700;
   NetTango ntango;
   
   
   Model(this.ntango) {
      turtles = [];
      for (int i=0; i<60; i++) {
         Turtle t = new Turtle(i, this);
         turtles.add(t);
         ntango.addTouchable(t);
      }
   }
   
   void restart() { }
   
   void tick(int count) {
      for (var turtle in turtles) {
         turtle.animate();
      }      
   }
 
   
   void draw(var ctx) {
      num psize = w / worldWidth;
      ctx.save();
      ctx.translate(w/2, h/2);
      ctx.scale(psize, -psize);
      
      for (var turtle in turtles) {
         turtle.draw(ctx);
      }
      ctx.restore();
   }
   
   
   num screenToWorldX(num sx, num sy) {
      return (sx - w/2) * (worldWidth / w);
   }
   
   num screenToWorldY(num sx, num sy) {
      return (h/2 - sy) * (worldHeight / h);      
   }
   
   
   int get maxPatchX => 12;
   int get maxPatchY => 12;
   int get minPatchX => -12;
   int get minPatchY => -12;
   num get minWorldY => minPatchY - 0.5;
   num get minWorldX => minPatchX - 0.5;
   num get maxWorldY => maxPatchY + 0.5;
   num get maxWorldX => maxPatchX + 0.5;
   int get worldWidth => maxPatchX - minPatchX + 1;
   int get worldHeight => maxPatchY - minPatchY + 1;
   
}