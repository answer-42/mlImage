(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Batteries
open Imagetypes

(* Change image *)
let rot_image_list op state = 
  let len = Array.length state.image_list in
  let new_id =   op state.current_image_id 1 
              |> flip (mod) len 
              |> fun x -> if x<0 then len+x else x
  in  
  state.current_image_id <- new_id;
  state.current_image <- Sdlloader.load_image state.image_list.(new_id);
  {state with fit_ratio = Zoomimage.change_fit_ratio state; offset = (0,0)}

let next_image = rot_image_list (+)
let prev_image = rot_image_list (-)


