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


void main() {
   new NetTango();
}


class NetTango extends TouchManager {
   
   CanvasRenderingContext2D pctx;
   CanvasRenderingContext2D tctx;
   CanvasRenderingContext2D gctx; // for plot
   
   Model model;
   
   Toolbar toolbar;
   

   // Plot (this will need to be replaced with something more generic!)
   StackGraph plot;


   int width = 1000;
   int height = 700;
   
   // current tick count
   int ticks = 0;
   
   
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
      pctx = canvas.getContext("2d");
      canvas.width = width;
      canvas.height = height;
      
      // Canvas for drawing turtles
      canvas = document.query("#turtles");
      tctx = canvas.getContext("2d");
      registerEvents(canvas);
      canvas.width = width;
      canvas.height = height;
      
      // Canvas for plot
      canvas = document.query("#plot");
      gctx = canvas.getContext("2d");
      plot = new StackGraph(canvas.width, canvas.height);
      
      // Create and resize the model
      model = new Model(this);
      model.resizeToFitScreen(width, height);
      play(1);
      
      toolbar = new Toolbar(model);
   }
 
 
/*
 * Restart the simulation
 */
   void restart() {
      ticks = 0;
      model.restart();
   }

   
/*
 * Tick: advance the model, animate, and repaint
 */
   void tick() {
      if (play_state != 0) {
         ticks++;
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
      if (ticks % 10 == 0) {
         plot.addDataPoint(ticks, model.turtles.length);
      }
   }


   void draw() {
      model.drawPatches(pctx);

      tctx.clearRect(0, 0, width, height);
      model.drawTurtles(tctx);
      plot.draw(gctx);
   }
}
