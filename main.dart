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
   
   Model model;
   Toolbar toolbar;
   
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
      canvas.width = width;
      canvas.height = height;

      
      // Create toolbar
      toolbar = new Toolbar(this);
      
      
      // Create and resize the model
      model = new Model(this);
      model.resizeToFitScreen(width, height);

      
      // Event capture layer
      canvas = document.query("#events");
      canvas.width = width;
      canvas.height = height;
      registerEvents(canvas);
      
      restart();
   }
 
 
/*
 * Restart the simulation
 */
   void restart() {
      pause();
      ticks = 0;
      model.setup();
      draw();
   }

   
/*
 * Tick: advance the model, animate, and repaint
 */
   void tick() {
      if (play_state != 0) {
         for (int i=0; i<play_state; i++) {
            ticks++;
            animate();
         }
         draw();
         window.setTimeout(tick, 20);
      }
   }
   
   
/*
 * Start the simulation
 */
   void play(num speedup) {
      play_state = speedup;
      tick();
   }
   

/*
 * Pause the simulation
 */
   void pause() {
      play_state = 0;
   }
   
   
/*
 * Speed up the simulation
 */
   void fastForward() {
      if (play_state < 8 && play_state > 0) {
         play_state *= 2;
      } else if (play_state == 0) {
         play(1);
      } else {
         play_state = 1;
      }
   }
   
   
/*
 * Step forward 1 tick 
 */
   void stepForward() {
      pause();
      ticks++;
      animate();
      draw();
   }
   
   
   void animate() {
      model.tick(play_state);
   }


   void draw() {
      model.drawPatches(pctx);
      tctx.clearRect(0, 0, width, height);
      model.drawTurtles(tctx);
      toolbar.draw();
   }
}
