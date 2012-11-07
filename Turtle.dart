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
class Turtle implements Touchable {
  
   static Random rnd = new Random();
   
   int id;            // all turtles have a unique id number
   num x = 0, y = 0;  // turtle coordinates in world space
   num size = 1;      // turtle size
   num heading = 0;   // turtle heading in radians
   Color color;       // turtle color
   Model model;       // reference back to the containing model
   bool dead = false; // flag used to remove turtle from the model

   
   Turtle(this.model) {
      id = model.nextTurtleId;
      heading = rnd.nextInt(360);
      color = new Color(255, 255, 0, 50);
   }
   
   
   Turtle clone(Turtle parent) {
      Turtle t = new Turtle(model);
      t.x = x;
      t.y = y;
      t.size = size;
      t.heading = heading;
      t.color = color.clone();
      t.dead = false;
      model.addTurtle(t);
      return t;
   }
   
   
   void forward(num distance) {
      x = wrapX(x - sin(heading) * distance);
      y = wrapY(y + cos(heading) * distance);
   }
   
      
   void backward(num distance) {
      forward(-distance);
   }
   
   
   void left(num degrees) {
      heading -= (degrees / 180) * PI;   
   }
   
   
   void right(num degrees) {
      left(-degrees);
   }
   
   
   void die() {
      dead = true;
      color.setColor(0, 0, 0, 255);
   }
   
   
   void hatch() {
      Turtle copy = clone(this);
   }
   
   
   num wrapX(num tx) {
      if (tx < model.minWorldX) {
         return tx + model.worldWidth;
      } else if (tx > model.maxWorldX) {
         return tx - model.worldWidth;
      } else {
         return tx;
      }
   }
   
   
   num wrapY(num ty) {
      if (ty < model.minWorldY) {
         return ty + model.worldHeight;
      } else if (ty > model.maxWorldY) {
         return ty - model.worldHeight;
      } else {
         return ty;
      }
   }
   
   
   void draw(var ctx) {
      ctx.save();
      ctx.translate(x, y); // translate to the origin
      ctx.rotate(heading); // rotate north
      roundRect(ctx, -0.2, -0.5, 0.4, 1, 0.2);
      ctx.fillStyle = color.toString();
      ctx.fill();
      ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
      ctx.lineWidth = 0.05;
      ctx.stroke();
      ctx.restore();
   }
   
   
   Patch patchHere() {
      return model.patchAt(x, y);
   }
   
   
   Patch patchAhead(distance) {
      num px = wrapX(x - sin(heading) * distance);
      num py = wrapY(y + cos(heading) * distance);
      return model.patchAt(x, y);
   }
   
   
   void animate() {
      if (dead) return;
      forward(0.1);
      right(rnd.nextInt(20));
      left(rnd.nextInt(20));
      Patch p = patchHere();
   }
   
   
   void roundRect(var ctx, num x, num y, num w, num h, num r) {
      ctx.beginPath();
      ctx.moveTo(x+r,y);
      ctx.arcTo(x+w,y,x+w,y+r,r);
      ctx.arcTo(x+w,y+h,x+w-r,y+h,r);
      ctx.arcTo(x,y+h,x,y+h-r,r);
      ctx.arcTo(x,y,x+r,y,r);
   }
   
   
   //-------------------------------------------------------------------
   // Touchable implementation
   //-------------------------------------------------------------------
   bool containsTouch(TouchEvent event) {
      double tx = model.screenToWorldX(event.touchX, event.touchY);
      double ty = model.screenToWorldY(event.touchX, event.touchY);
      return (tx >= x-size/2 && tx <= x+size/2 && ty >= y-size/2 && ty <= y+size/2);
   }
   
   
   bool touchDown(TouchEvent event) {
      color.setColor(255, 0, 0, 255);
      return true;
   }
   
   
   void touchUp(TouchEvent event) {
      color.setColor(0, 255, 0, 255);
   }
   
   
   void touchDrag(TouchEvent event) {      
      double tx = model.screenToWorldX(event.touchX, event.touchY);
      double ty = model.screenToWorldY(event.touchX, event.touchY);
      x = tx;
      y = ty;
   }
   
   
   void touchSlide(TouchEvent event) { }
}