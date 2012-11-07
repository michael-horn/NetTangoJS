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
class Toolbar {

   var buttons;
   var ctx;  // drawing context
   Button target = null;
   Model model;
   int pstate = 0;
   int width = 440;
   int height = 70;
   int x, y;
   
   Button playButton;
   Button pauseButton;
   //Button scrubButton;
   //Button fullButton;
   //Button partButton;
   //protected int scrubMax;
   //protected boolean fullscreen = false;

   
   Toolbar(this.model) {
      
      CanvasElement canvas = document.query("#toolbar");
      ctx = canvas.getContext("2d");
      width = canvas.width;
      height = canvas.height;

      buttons = new List<Button>();
      //this.scrubMax = model.getStream().getCapacity();

      int w = width;
      int h = height;
      int bw = 40;
      int bh = 30;
      int bx = 0;
      int by = 8;

      Button button;

      button = new Button(w~/2 - bw~/2 + 3, by, bw, bh, "play");
      button.setImage("images/play.png");
      TouchManager.addTouchable(button);
      buttons.add(button);
      button.onClick = action;
      button.onDown = action;
      button.enabled = (pstate == 0);
      button.visible = (pstate == 0);
      playButton = button;
      
      button = new Button(w~/2 - bw~/2 + 3, by, bw, bh, "pause");
      button.setImage("images/pause.png");
      button.onClick = action;
      button.onDown = action;
      TouchManager.addTouchable(button);
      button.visible = (pstate != 0);
      button.enabled = (pstate != 0);
      buttons.add(button);
      pauseButton = button;
      bx += bw;

      button = new Button(w~/2 + bx - bw~/2, by, bw, bh, "fastforward");
      button.setImage("images/fastforward.png");
      button.onClick = action;
      button.onDown = action;
      TouchManager.addTouchable(button);
      buttons.add(button);
      
      button = new Button(w~/2 - bw~/2 - bx, by, bw, bh, "rewind");
      button.setImage("images/rewind.png");
      button.onClick = action;
      button.onDown = action;
      TouchManager.addTouchable(button);
      buttons.add(button);
      bx += bw;

      button = new Button(w~/2 + bx - bw~/2, by, bw, bh, "stepforward");
      button.setImage("images/stepforward.png");
      button.onClick = action;
      button.onDown = action;
      TouchManager.addTouchable(button);
      buttons.add(button);
      
      button = new Button(w~/2 - bx - bw~/2, by, bw, bh, "stepback");
      button.setImage("images/stepback.png");
      button.onClick = action;
      button.onDown = action;
      TouchManager.addTouchable(button);
      buttons.add(button);

      bx = 10;
      button = new Button(bx, by, bw, bh, "restart");
      button.setImage("images/restart.png");
      button.onClick = action;
      button.onDown = action;
      TouchManager.addTouchable(button);
      buttons.add(button);
      
/*      
      bx = w - 10 - bw;
      button = new Button(bx, by, bw, bh, "fullscreen");
      button.setImage("/images/fullscreen.png");
      buttons.add(button);
      fullButton = button;
      
      button = new Button(bx, by, bw, bh, "partscreen");
      button.setImage("/images/partscreen.png");
      buttons.add(button);
      button.setVisible(false);
      button.setEnabled(false);
      partButton = button;

      bw = 250;
      bh = 10;
      bx = w/2 - bw/2;
      by = h - bh/2 - 10;

      button = new Button(bx - 10, by - 10, 20, 20, "ball");
      button.setImage("/images/ball.png");
      buttons.add(button);
      scrubButton = button;
*/
      window.setTimeout(draw, 200);
   }
   
   void action(var act) {
      draw();
   }
   
   
   bool isPlaying() {
      return pstate > 0;
   }
   
   
   bool isPaused() {
      return pstate == 0;
   }
   
/*   
   bool isFullscreen() {
      return fullscreen;
   }
*/ 

   void draw() {
      
      int w = width;
      int h = height;
      ctx.clearRect(0, 0, width, height);

      for (var button in buttons) {
         button.draw(ctx);
      }

      //---------------------------------------------
      // Draw speedup
      //---------------------------------------------
      /*
      g.setFont(Palette.FONT_H1);
      if (pstate > 1) {
         g.drawString("x" + pstate, w/2 - 160, h - 10);
      }
      else if (pstate < -1) {
         g.drawString("x" + (pstate * -1), w/2 - 160, h - 10);
      }
      */
      
      //---------------------------------------------
      // Draw tick counter
      //---------------------------------------------
      /*
      g.setFont(Palette.FONT_BODY);
      String s = "tick: " + model.getPlayHead();
      int fw = g.getFontMetrics().stringWidth(s);
      g.drawString(s, w - fw - 10, h - 15);
      */
      
      //---------------------------------------------
      // Draw the scrub bar
      //---------------------------------------------
      /*
      int bw = 250;
      int bh = 10;
      int bx = w/2 - bw/2;
      int by = h - bh - 10;
      g.setColor(Color.DARK_GRAY);
      g.fillRect(bx, by, bw, bh);

      SimStream stream = model.getStream();
      float scale = (float)bw / scrubMax;
      int min = (int)(stream.getMinIndex() * scale);
      int max = (int)(stream.getMaxIndex() * scale);

      g.setColor(Color.LIGHT_GRAY);
      g.fillRect(bx + min, by, max - min, bh);

      g.setColor(Color.GRAY);
      g.drawRect(bx, by, bw, bh);
      */

      //---------------------------------------------
      // Move the play head
      //---------------------------------------------
      /*
      int index = model.getPlayHead();
      bx += (int)(index * scale);
      by += bh / 2;
      scrubButton.reshape(bx - 10, by - 10, 20, 20);
      */
   }

   /*
   boolean flip = false;
   protected void movePlayHead(int delta) {
      if (flip && Math.abs(delta) == 1) return;
      if (Math.abs(delta) > 1) delta /= 2;
      SimStream stream = model.getStream();
      int index = model.getPlayHead() + delta;
      if (!model.isLoaded()) return;
      while (index > stream.getMaxIndex()) {
         model.tick();
      }
      model.setPlayHead(index);
      if (index <= stream.getMinIndex()) pstate = 0;
   }
   */

   
   void animate() {
      /*
      flip = !flip;
      SimStream stream = model.getStream();

      // Adjust size of scrub bar if necessary
      int index = model.getPlayHead();
      if (stream.getMaxIndex() == 0) {
         scrubMax = stream.getCapacity();
      } else if (index * 1.15f > scrubMax) {
         scrubMax *= 2;
      }
      
      // fill the simulation buffer
      if (!stream.isBufferFull()) {
         //model.tick();
      }
      
      // play or fastforward
      movePlayHead(pstate);
      */
   }
/*
   public void onClick(Button button) {
      Main app = Main.instance;
      if ("play".equals(button.getAction())) {
         this.pstate = 1;
      } else if ("pause".equals(button.getAction())) {
         this.pstate = 0;
      } else if ("restart".equals(button.getAction())) {
         model.setup();
         app.layout(app.getWidth(), app.getHeight());
         this.pstate = 0;
      } else if ("fastforward".equals(button.getAction())) {
         if (pstate <= 0 || pstate >= 8) {
            pstate = 1;
         } else if (pstate > 0 && pstate < 8) {
            pstate *= 2;
         } 
      } else if ("rewind".equals(button.getAction())) {
         if (pstate >= 0 || pstate <= -8) {
            pstate = -1;
         } else if (pstate < 0 && pstate > -8) {
            pstate *= 2;
         }
      } else if ("stepforward".equals(button.getAction())) {
         pstate = 0;
         movePlayHead(1);
      } else if ("stepback".equals(button.getAction())) {
         pstate = 0;
         movePlayHead(-1);
      } else if ("fullscreen".equals(button.getAction())) {
         fullButton.setVisible(false);
         fullButton.setEnabled(false);
         partButton.setVisible(true);
         partButton.setEnabled(true);
         this.fullscreen = true;
         app.enterFullscreen();
         
      } else if ("partscreen".equals(button.getAction())) {
         fullButton.setVisible(true);
         fullButton.setEnabled(true);
         partButton.setVisible(false);
         partButton.setEnabled(false);
         this.fullscreen = false;
         app.exitFullscreen();
      }
      
      
      playButton.setEnabled(pstate == 0);
      playButton.setVisible(pstate == 0);
      pauseButton.setEnabled(pstate != 0);
      pauseButton.setVisible(pstate != 0);
   }
   */

}