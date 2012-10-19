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
 class Patch {
   
   // patch coordinates
   int x, y;
   
   // patch color
   Color color;
   
   // only draw a patch if it needs updating
   bool dirty = true;
   
   int energy = 0;

   
   Patch(this.x, this.y) {
      color = new Color(255, 255, 0, 255);
   }
   
   
   void animate() {
      if (color.alpha > 0) {
         color.alpha = color.alpha - 1;
         dirty = true;
      }
   }

   
   void draw(var ctx) {
      if (dirty) {
         ctx.clearRect(x - 0.5, y - 0.5, 1, 1);
         ctx.fillStyle = color.toString();
         ctx.fillRect(x - 0.5, y - 0.5, 1, 1);
         ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
         ctx.lineWidth = 0.03;
         ctx.strokeRect(x - 0.5, y - 0.5, 1, 1);
         dirty = false;
      }
   }
}