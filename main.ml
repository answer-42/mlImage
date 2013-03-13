open Sdlevent
open Sdlkey

(* Type Declarations 
 ********************)
type pos       = int * int
type view_mode = 
  Fit | Zoom of float| Full
  
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
  }

let no_images = 1
let success   = 0

(* Zoom step *)
let step = 0.05

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

let change_fit_ratio state =
  let cur_im       = state.current_image in 
  let image_width  = width (Sdlvideo.surface_dims cur_im) in
  let image_height = height (Sdlvideo.surface_dims cur_im) in
  min (state.window_w//image_width) (state.window_h//image_height)

(* Change image *)
let rot_image_list op state = 
  (* TODO change so that it only has to load image once! *)
  let new_id   = op state.current_image_id 1 in
  let new_id'  = new_id mod (Array.length state.image_list) in
  let new_id'' = if new_id' < 0 
                 then (Array.length state.image_list)+new_id'
                 else new_id'
              in
  state.current_image_id <- new_id'';
  state.current_image <- Sdlloader.load_image state.image_list.(new_id'');
  state.fit_ratio <- change_fit_ratio state;
  state

let next_image = rot_image_list (+)
let prev_image = rot_image_list (-)

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
  Sdlvideo.blit_surface img state.screen ();

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
  | VIDEORESIZE (w,h)           -> run (resize w h state) true
  | e -> run state false

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
  let img = Sdlloader.load_image images.(cur_img_id) in
  let s_width =  width (Sdlvideo.surface_dims screen) in
  let s_height = height (Sdlvideo.surface_dims screen) in
  let image_width  = width (Sdlvideo.surface_dims img) in
  let image_height = height (Sdlvideo.surface_dims img) in
  let ratio =  min (s_width//image_width) (s_height//image_height) in

  (* Constructing inital state *)
  let state = {
    screen = screen;
    current_image    = img;
    current_image_id = cur_img_id;
    image_list       = images;
    window_w         = s_width;
    window_h         = s_height;
    mode             = Fit;
    fit_ratio        = ratio;
    offset           = (0,0);
  } in

  run state true
    
let () = main ()
