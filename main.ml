open Sdlevent
open Sdlkey

(* Type Declarations 
 ********************)
type pos       = int * int
type view_mode = 
  Fit | Zoom of float | Full
  
type config_state =
  {
    mutable screen           : Sdlvideo.surface;
    mutable current_image_id : int;
            image_list       : string array;
    mutable window_w         : int;
    mutable window_h         : int;
    mutable mode             : view_mode;
    mutable offset           : pos;
  }

let no_images = 1
let success   = 0

(* Helpers 
 **********)

let (//) x y = (float_of_int x) /. (float_of_int y)

let width (w,h,p)  = w
let height (w,h,p) = h

(* Supporting functions 
 ***********************)

(* Get a list of files/dirs, and returns image files recusively *)
let get_images l =
  (* Here we can add more accepted picture types *)
  let is_image x = List.exists (Filename.check_suffix x)
                      [".jpg"; ".JPG"; ".jpeg"; ".JPEG"] 
  in
  (* TODO At the moment it only takes pictures. Doesen't decent into the
   * directories recursively *)
  List.find_all is_image l

(* Change image *)
let rot_image_list op state = 
  let new_id   = op state.current_image_id 1 in
  let new_id'  = new_id mod (Array.length state.image_list) in
  let new_id'' = if new_id' < 0 
                 then (Array.length state.image_list)+new_id'
                 else new_id'
              in
  state.current_image_id <- new_id'';
  state

let next_image = rot_image_list (+)
let prev_image = rot_image_list (-)

(* Zoom current image *)
let zoom_image op state =
  let step = 10.0 in
  match state.mode with
    Zoom x -> state.mode <- Zoom (op x step);
              state
  | _      -> state.mode <- Zoom (op 0.0 step);
              state

let zoom_in  = zoom_image (+.)
let zoom_out = zoom_image (-.)


let render_fit_image state =
  let cur_im = Sdlloader.load_image state.image_list.(state.current_image_id) in
  let image_width  = width (Sdlvideo.surface_dims cur_im) in
  let image_height = height (Sdlvideo.surface_dims cur_im) in
  state.window_w <- width (Sdlvideo.surface_dims state.screen);
  state.window_h <- height (Sdlvideo.surface_dims state.screen);
  let ratio        = min (state.window_w // image_width) (state.window_h // image_height) in
  Sdlgfx.rotozoomSurface cur_im ratio ratio false

let render_zoom_image state ratio=
  Sdlgfx.rotozoomSurface 
    (Sdlloader.load_image state.image_list.(state.current_image_id))
    ratio ratio false

let render state =
  let img = 
    match state.mode with
      Fit        -> render_fit_image state
    | Zoom ratio -> render_zoom_image state ratio 
    | Full       -> Sdlloader.load_image state.image_list.(state.current_image_id);
  in
  Sdlvideo.blit_surface img state.screen ();

  Sdlvideo.flip state.screen



(* Eventloop 
 ************)
let rec run state =
  render state;
  match wait_event () with
    KEYDOWN {keysym=KEY_ESCAPE} -> exit success
  | KEYDOWN {keysym=KEY_RIGHT}  -> run (next_image state) 
  | KEYDOWN {keysym=KEY_LEFT}   -> run (prev_image state)
  (* TODO: Zoom not working segmentation fault *)
  | KEYDOWN {keysym=KEY_i}      -> run (zoom_in state)
  | KEYDOWN {keysym=KEY_o}      -> run (zoom_out state)
  | KEYDOWN {keysym=KEY_f}      -> state.mode <- Fit;
                                   run state
  | KEYDOWN {keysym=KEY_z}      -> state.mode <- Full;
                                   run state
  | e -> print_endline (string_of_event e); 
         run state

(* Main 
 *******)
let main () =
  
  (* Getting commandline arguments *)
  let args   = Array.to_list Sys.argv in
  let images = Array.of_list (get_images args) in
  let cur_img_id = 0 in
  (* At least one image is needed to continue *)
  if Array.length images < 1 then exit no_images;


  Sdl.init [`VIDEO];
  at_exit Sdl.quit;

  let screen = Sdlvideo.set_video_mode 0 0 [] in

  (* Constructing inital state *)
  let state = {
    screen = screen;
    current_image_id = cur_img_id;
    image_list       = images;
    window_w         = width (Sdlvideo.surface_dims screen);
    window_h         = height (Sdlvideo.surface_dims screen);
    mode             = Full;
    offset           = (0,0);
  } in

  run state
    
let () = main ()
