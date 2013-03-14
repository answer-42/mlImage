(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

(* Type Declarations 
 ********************)
type pos       = int * int;;
type view_mode = 
  Fit | Zoom of float| Full;;
  
type config_state =
  {
    mutable screen           : Sdlvideo.surface;
    mutable current_image    : Sdlvideo.surface;
    mutable current_image_id : int;
            image_list       : string array;
    mutable window_w         : int;
    mutable window_h         : int;
    mutable fit_ratio        : float;
    mutable mode             : view_mode;
    mutable offset           : pos;
  };;


