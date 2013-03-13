open Imagetypes
open Helpers

(* Zoom step *)
let step = 0.05

let change_fit_ratio state =
  let cur_im       = state.current_image in 
  let image_width  = width (Sdlvideo.surface_dims cur_im) in
  let image_height = height (Sdlvideo.surface_dims cur_im) in
  min (state.window_w//image_width) (state.window_h//image_height)

(* Zoom current image *)
let zoom_image op state =
  match state.mode with
    Zoom x -> state.mode <- Zoom (op x step) ;
              state
  | Full   -> state.mode <- Zoom (op 1.0 step);
              state
  | _      -> state.mode <- Zoom (op state.fit_ratio step);
              state

let zoom_in  = zoom_image (+.)
let zoom_out = zoom_image (-.)

let resize w h state =
  state.window_w <- w;
  state.window_h <- h;
  state.fit_ratio <- change_fit_ratio state;
  state


