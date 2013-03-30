(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)
open Batteries

open Imagetypes
open Helpers

(* TODO: Currently it always zooms such that the viewing window is moving too
 * the  upper left corner. I think the problem lies in the fact that the offset
 * is not changing when zooming in/out.
 *I would like to change it such that it zooms into the  middle of the open window. 
 *)

(* Zoom step *)
let step = 0.1

let change_fit_ratio state =
  let (image_w,image_h,_)  = Sdlvideo.surface_dims state.current_image in
  min (state.window_w//image_w) (state.window_h//image_h)

(* Zoom current image *)
let zoom_image op state =
  match state.mode with
  | Zoom x -> {state with mode = Zoom (op x step)}
  | Full   -> {state with mode = Zoom (op 1.0 step)}
  | _      -> {state with mode = Zoom (op state.fit_ratio step)}

let zoom_in  = zoom_image (+.)
let zoom_out = zoom_image (-.)

let resize w h state =
  state.window_w <- w;
  state.window_h <- h;
  {state with fit_ratio = change_fit_ratio state}

