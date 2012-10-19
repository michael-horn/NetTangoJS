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
#source('JsonObject.dart');


void main() {
   new NetTango();
}


class NetTango extends TouchManager {
   
   CanvasRenderingContext2D pctx;
   CanvasRenderingContext2D tctx;
   
   Model model;

   int width = 1000;
   int height = 700;
   
   
   //-------------------------------------------
   // Play state
   //   -2 : play backward 2x
   //   -1 : play backward normal speed
   //   0  : paused
   //   1  : play forward normal speed
   //   2  : play forward 2x
   //   4  : play forward 4x ....
   //-------------------------------------------
   int play_state = 0; 

   
   NetTango() {
      width = window.innerWidth;
      height = window.innerHeight;
  
      // Canvas for drawing patches
      CanvasElement canvas = document.query("#patches");
      canvas.width = width;
      canvas.height = height;
      pctx = canvas.getContext("2d");
      
      // Canvas for drawing turtles
      canvas = document.query("#turtles");
      canvas.width = width;
      canvas.height = height;
      tctx = canvas.getContext("2d");
      registerEvents(canvas);
      
      // Create and resize the model
      model = new Model(this);
      model.resizeToFitScreen(width, height);
      play(1);
   }
 
 
/*
 * Restart the simulation
 */
   void restart() {
      model.restart();
   }

   
/*
 * Tick: advance the model, animate, and repaint
 */
   void tick() {
      if (play_state != 0) {
         animate();
         draw();
         window.setTimeout(tick, 20);
      }
   }
   
   
/*
 * Start the simulation
 */
   void play(num speedup) {
      play_state = speedup;
      print("play");
      tick();
   }
   

/*
 * Pause the simulation
 */
   void pause() {
      play_state = 0;
   }
   
   
   void animate() {
      model.tick(play_state);
   }


   void draw() {
      model.drawPatches(pctx);

      tctx.clearRect(0, 0, width, height);
      model.drawTurtles(tctx);
      
   }
}
