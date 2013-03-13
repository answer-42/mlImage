open Imagetypes

(* Change image *)
let rot_image_list op state = 
  let len = Array.length state.image_list in
  let new_id   = op state.current_image_id 1 in
  let new_id'  = new_id mod len in
  let new_id'' = if new_id' < 0 
                 then len + new_id'
                 else new_id'
              in
  state.current_image_id <- new_id'';
  state.current_image <- Sdlloader.load_image state.image_list.(new_id'');
  state.fit_ratio <- Zoomimage.change_fit_ratio state;
  state.offset <- (0,0);
  state

let next_image = rot_image_list (+)
let prev_image = rot_image_list (-)


