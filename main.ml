(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Eventhandling
open Imagetypes
open Helpers

let initalize args =
  let images = Array.of_list (Imagepaths.get_images args) in
  let cur_img_id = 0 in
  (* At least one image is needed to continue *)
  if Array.length images < 1 then exit no_images;

  let screen = Sdlvideo.set_video_mode 0 0 [] in
  let img = Sdlloader.load_image images.(cur_img_id) in
  let s_width =  width (Sdlvideo.surface_dims screen) in
  let s_height = height (Sdlvideo.surface_dims screen) in
  let image_width  = width (Sdlvideo.surface_dims img) in
  let image_height = height (Sdlvideo.surface_dims img) in
  let ratio =  min (s_width//image_width) (s_height//image_height) in

  (* Constructing inital state *)
  {
    screen = screen;
    current_image    = img;
    current_image_id = cur_img_id;
    image_list       = images;
    window_w         = s_width;
    window_h         = s_height;
    mode             = Fit;
    fit_ratio        = ratio;
    offset           = (0,0);
  }

(* Main 
 *******)
let main () =

  (* Getting commandline arguments *)
  (* TODO takes element 0 (filename also as imagepath *)
  let args   = Sys.argv in

  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
 
  run (initalize args) true
    
let () = main ()

