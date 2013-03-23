(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Batteries

open Sdlevent
open Sdlkey

open Imagetypes
open Helpers

module Change = Changeimage;; 
module Move   = Moveimage;;
module Zoom   = Zoomimage;;
module Text   = Showtext
(* Rendering functions 
 **********************)

let clear state =
  Sdlvideo.fill_rect state.screen Int32.zero;;

let render_fit_image state =
  let cur_im = state.current_image in
  let ratio = state.fit_ratio in
  Sdlgfx.zoomSurface cur_im ratio ratio false;;

let render_zoom_image state ratio =
  Sdlgfx.zoomSurface 
    state.current_image
    ratio ratio false;;

let render state =
  let img = 
    match state.mode with
    | Fit       -> render_fit_image state
    | Zoom ratio -> render_zoom_image state ratio
    | Full       -> Sdlloader.load_image state.image_list.(state.current_image_id);
  in
  clear state;
  let (x,y) = state.offset in
  let rect = { Sdlvideo.r_x = x;
               Sdlvideo.r_y = y;
               (* The following two values are ignored *)
               Sdlvideo.r_w = 0;
               Sdlvideo.r_h = 0;
             }
  in
  Sdlvideo.blit_surface ~dst_rect:rect ~src:img ~dst:state.screen ();

  if state.text == Info then
    Text.render_info state
  else if (state.text == Help) then
    Text.render_help state;

  Sdlvideo.flip state.screen;;

(* Eventloop 
 ************)
let rec run state changed =
  if changed then render state;
  match wait_event () with
  | KEYDOWN {keysym=KEY_ESCAPE} -> exit success
  | KEYDOWN {keysym=KEY_RIGHT}  -> run (Change.next_image state) true 
  | KEYDOWN {keysym=KEY_LEFT}   -> run (Change.prev_image state) true
  | KEYDOWN {keysym=KEY_i}      -> run (Zoom.zoom_in state) true
  | KEYDOWN {keysym=KEY_o}      -> run (Zoom.zoom_out state) true
  | KEYDOWN {keysym=KEY_f}      -> run {state with mode = Fit} true
  | KEYDOWN {keysym=KEY_z}      -> run {state with mode = Full} true
  | KEYDOWN {keysym=KEY_s}      -> run (Move.move_down state) true
  | KEYDOWN {keysym=KEY_w}      -> run (Move.move_up state) true
  | KEYDOWN {keysym=KEY_a}      -> run (Move.move_left state) true
  | KEYDOWN {keysym=KEY_d}      -> run (Move.move_right state) true
  | KEYDOWN {keysym=KEY_t}      -> run {state with text = Info} true
  | KEYDOWN {keysym=KEY_h}      -> run {state with text = Help} true
  | KEYDOWN {keysym=KEY_n}      -> run {state with text = None} true
  | VIDEORESIZE (w,h)           -> run (Zoom.resize w h state) true
  | e -> run state false
  ;;

