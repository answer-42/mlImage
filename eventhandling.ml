(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Sdlevent
open Sdlkey

open Imagetypes
open Changeimage
open Moveimage
open Zoomimage
open Helpers

let no_images = 1
let success   = 0

(* Supporting functions 
 ***********************)

let clear state =
  Sdlvideo.fill_rect state.screen Int32.zero

let render_fit_image state =
  let cur_im = state.current_image in
  let ratio = state.fit_ratio in
  Sdlgfx.zoomSurface cur_im ratio ratio false

let render_zoom_image state ratio =
  Sdlgfx.zoomSurface 
    state.current_image
    ratio ratio false

let render state =
  let img = 
    match state.mode with
      Fit       -> render_fit_image state
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

  Sdlvideo.flip state.screen

(* Eventloop 
 ************)
let rec run state changed =
  if changed then render state;
  match wait_event () with
    KEYDOWN {keysym=KEY_ESCAPE} -> exit success
  | KEYDOWN {keysym=KEY_RIGHT}  -> run (next_image state) true 
  | KEYDOWN {keysym=KEY_LEFT}   -> run (prev_image state) true
  | KEYDOWN {keysym=KEY_i}      -> run (zoom_in state) true
  | KEYDOWN {keysym=KEY_o}      -> run (zoom_out state) true
  | KEYDOWN {keysym=KEY_f}      -> state.mode <- Fit;
                                   run state true
  | KEYDOWN {keysym=KEY_z}      -> state.mode <- Full;
                                   run state true 
  | KEYDOWN {keysym=KEY_s}      -> run (move_down state) true
  | KEYDOWN {keysym=KEY_w}      -> run (move_up state) true
  | KEYDOWN {keysym=KEY_a}      -> run (move_left state) true
  | KEYDOWN {keysym=KEY_d}      -> run (move_right state) true
  | VIDEORESIZE (w,h)           -> run (resize w h state) true
  | e -> run state false


