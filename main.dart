#library('nettango');

#import('dart:html');
#import('dart:math');
#import('dart:json');

#source('Touch.dart');
#source('Turtle.dart');
#source('Tween.dart');
#source('Model.dart');
#source('JsonObject.dart');


void main() {
   new NetTango();
}


class NetTango extends TouchManager {
   
   CanvasRenderingContext2D background;
   CanvasRenderingContext2D foreground;
   
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
      CanvasElement canvas = document.query("#layer1");
      background = canvas.getContext("2d");
      
      canvas = document.query("#layer2");
      foreground = canvas.getContext("2d");
      registerEvents(canvas);
      
      width = canvas.width;
      height = canvas.height;
      
      model = new Model(this);
      drawBackground();
      play(1);
   }
 
 
/*
 * Restart the simulation
 */
   void restart() {
      model.restart();
      drawBackground();
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
      var ctx = foreground;
      ctx.clearRect(0, 0, width, height);
      model.draw(ctx);
   }

   
   void drawBackground() {
      var ctx = background;
      ctx.clearRect(0, 0, width, height);
   }
}
