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
class Color {
   int r = 255, g = 255, b = 255, a = 255;
   
   Color(this.r, this.g, this.b, this.a);
   
   int get red => r;
       set red(int r) { if (r >= 0) { this.r = r < 256? r : 255; }}
   int get green => g;
       set green(int g) { if (g >= 0) { this.g = g < 256? g : 255; }}
   int get blue => b;
       set blue(int b) { if (b >= 0) { this.b = b < 256? b : 255; }}
   int get alpha => a;
       set alpha(int a) { if (a >= 0) { this.a = a < 256? a : 255; }}
       
   String toString() {
      num ad = a / 255;
      return "rgba($r, $g, $b, $ad)";
   }
}
