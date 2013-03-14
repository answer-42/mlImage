(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Imagetypes
open Helpers

(* TODO: Currently it always zooms such that the viewing window is moving too
 * the  upper left corner.  I would like to change it such that it zooms into the
 * middle of the open window. 
 *)

(* Zoom step *)
let step = 0.1;;

let change_fit_ratio state =
  let cur_im       = state.current_image in 
  let image_width  = width (Sdlvideo.surface_dims cur_im) in
  let image_height = height (Sdlvideo.surface_dims cur_im) in
  min (state.window_w//image_width) (state.window_h//image_height);;

(* Zoom current image *)
let zoom_image op state =
  match state.mode with
    Zoom x -> {state with mode = Zoom (op x step)}
  | Full   -> {state with mode = Zoom (op 1.0 step)}
  | _      -> {state with mode = Zoom (op state.fit_ratio step)}
;;

let zoom_in  = zoom_image (+.);;
let zoom_out = zoom_image (-.);;

let resize w h state =
  state.window_w <- w;
  state.window_h <- h;
  {state with fit_ratio = change_fit_ratio state};;


