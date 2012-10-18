

class Turtle implements Touchable {
   var rnd = new Random();
   int id;
   num x = 3;
   num y = 1.5;
   num size = 1;
   num heading = 0;
   var color = "rgba(255, 255, 0, 0.3)";
   bool dead = false;
   Tween tween;
   Model model;
   
   
   Turtle(this.id, this.model) {
      heading = rnd.nextInt(360);
      /*
      tween = new Tween();
      tween.addControlPoint(0, 0);
      tween.addControlPoint(4, 1);
      tween.delay = 10;
      tween.duration = 20;
      tween.function = TWEEN_SINE2;
      tween.ondelta = ((val) => (forward(val)));
      tween.play();
      */
   }
   
   
   void forward(num distance) {
      x -= sin(heading) * distance;
      y += cos(heading) * distance;
      
      if (x < model.minWorldX) {
         x += model.worldWidth;
      }
      else if (x > model.maxWorldX) {
         x -= model.worldWidth;
      }
      if (y < model.minWorldY) {
         y += model.worldHeight;
      }
      else if (y > model.maxWorldY) {
         y -= model.worldHeight;
      }
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
   
   
   void draw(var ctx) {
      ctx.save();
      ctx.translate(x, y); // translate to the origin
      ctx.rotate(heading); // rotate north
      roundRect(ctx, -0.2, -0.5, 0.4, 1, 0.2);
      ctx.fillStyle = color;
      ctx.fill();
      ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
      ctx.lineWidth = 0.05;
      ctx.stroke();
      ctx.restore();
   }
   
   
   void animate() {
      //tween.animate();
      forward(0.1);
      right(rnd.nextInt(20));
      left(rnd.nextInt(20));
   }
   
   
   void roundRect(var ctx, num x, num y, num w, num h, num r) {
      ctx.beginPath();
      ctx.moveTo(x+r,y);
      ctx.arcTo(x+w,y,x+w,y+r,r);
      ctx.arcTo(x+w,y+h,x+w-r,y+h,r);
      ctx.arcTo(x,y+h,x,y+h-r,r);
      ctx.arcTo(x,y,x+r,y,r);
   }
   
   
   bool containsTouch(TouchEvent event) {
      double tx = model.screenToWorldX(event.touchX, event.touchY);
      double ty = model.screenToWorldY(event.touchX, event.touchY);
      return (tx >= x-size/2 && tx <= x+size/2 &&
              ty >= y-size/2 && ty <= y+size/2);
   }
   
   
   void touchDown(TouchEvent event) {
      color = "red";
   }
   
   
   void touchUp(TouchEvent event) {
      color = "green";
   }
   
   
   void touchDrag(TouchEvent event) {      
      double tx = model.screenToWorldX(event.touchX, event.touchY);
      double ty = model.screenToWorldY(event.touchX, event.touchY);
      x = tx;
      y = ty;
   }
}