
class Button implements Touchable {

   var action;
   var img;
   int x, y, w, h;
   var onClick, onDown;
   
   bool enabled = true;
   bool down = false;
   bool visible = true;
   bool checked = false;
   

   Button(this.x, this.y, this.w, this.h, this.action);

   void setImage(var path) {
      img = new ImageElement();
      img.src = path;
   }
   
   bool containsTouch(TouchEvent event) {
      num tx = event.touchX;
      num ty = event.touchY;
      return (tx >= x && ty >= y && tx <= x + w && ty <= y + h);
   }
   
   bool touchDown(TouchEvent event) {
      down = true;
      if (onDown != null) onDown(action);
      return true;
   }
   
   void touchUp(TouchEvent event) {
      down = false;
      if (onClick != null && containsTouch(event)) {
         onClick(action);
      }
   }
   
   void touchDrag(TouchEvent event) { 
      down = containsTouch(event);
   }
   
   void touchSlide(TouchEvent event) { }

   
   void draw(var ctx) {
      if (!visible) return;
      int ix = down? x + 2 : x;
      int iy = down? y + 2 : y;
      int iw = img.width;
      int ih = img.height;
      
      ctx.drawImage(img, ix, iy, iw, ih);
   }
}
