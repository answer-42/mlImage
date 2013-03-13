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


