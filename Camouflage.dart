#library('nettango');
#import('dart:html');
#import('dart:math');
#import('dart:json');

#source('Color.dart');
#source('Touch.dart');
#source('Turtle.dart');
#source('Patch.dart');
#source('Tween.dart');
#source('Model.dart');
#source('Toolbar.dart');
#source('Button.dart');
#source('StackGraph.dart');
#source('JsonObject.dart');
#source('NetTango.dart');


void main() {
   CamoModel model = new CamoModel();
   NetTango ntango = new NetTango(model);
   ntango.restart();
   ntango.play(1);
}


class CamoModel extends Model { 
  
   final int TURTLE_COUNT = 60;
   
   CamoModel() : super() {  
      patchSize = 20;
   }
   
   
   void setup() {
      clearTurtles();
      for (int i=0; i<TURTLE_COUNT; i++) {
         CamoTurtle t = new CamoTurtle(this);
         addTurtle(t);
         t.setXY(Model.rnd.nextInt(100), 
                 Model.rnd.nextInt(100));
      }
   }
}


class CamoTurtle extends Turtle {
   
   CamoTurtle(Model model) : super(model) {
      color.red = Turtle.rnd.nextInt(255);
      color.green = Turtle.rnd.nextInt(255);
      color.blue = Turtle.rnd.nextInt(255);
      color.alpha = 100;
      drawShape = drawCircle;
   }
   
   
   void tick() {
      // do nothing on tick
   }
   
   
   bool touchDown(TouchEvent event) {
      die();
      CamoTurtle t = model.oneOfTurtles();
      t.reproduce();
      return true;
   }
   
   
   void drawCircle(var ctx) {
      roundRect(ctx, -.4, -.4, 1, 1, .2);
      ctx.fillStyle = color.toString();
      ctx.fill();
   }
   
   
   void reproduce() {
      CamoTurtle copy = new CamoTurtle(model);
      copy.x = x;
      copy.y = y;
      copy.color.red += (10 - Turtle.rnd.nextInt(20));
      copy.color.green += (10 - Turtle.rnd.nextInt(20));
      copy.color.blue += (10 - Turtle.rnd.nextInt(20));
      copy.right(Turtle.rnd.nextInt(360));
      copy.forward(Turtle.rnd.nextDouble() * 0.5);
      model.addTurtle(copy);
   }
}