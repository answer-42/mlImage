(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)
open Batteries

open Imagetypes

let usage =
    "mlImage <image/dir list>\n\n"^
    "esc       Quit the program\n"^
    "right     Next image\n"^
    "left      Prev image\n"^
    "a         Move image left\n"^
    "d         Move image right\n"^
    "s         Move image down\n"^
    "w         Move image up\n"^
    "i         Zoom in\n"^
    "o         Zoom out\n"^
    "f         Fit image\n"^
    "z         Full image"

