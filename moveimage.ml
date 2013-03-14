(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Imagetypes
(* open Helpers *)

(* TODO: y/x-step should be dependent on imagesize *)
let xstep state = 50;; 
let ystep state = 50;;

let move_vert op state =
  let (x,y) = state.offset in
  {state with offset = (x,op y (ystep state))};;

let move_hor op state =
  let (x,y) = state.offset in
  {state with offset = (op x (xstep state),y)};;


let move_up   = move_vert (-);;
let move_down = move_vert (+);;

let move_right = move_hor (+);;
let move_left  = move_hor (-);;

