(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Imagetypes

(* TODO make steps depend on image size *)
let step = 30

let move_vert op state =
  let (x,y) = state.offset in
  state.offset <- (x,op y step);
  state

let move_hor op state =
  let (x,y) = state.offset in
  state.offset <- (op x step,y);
  state


let move_up   = move_vert (-)
let move_down = move_vert (+)

let move_right = move_hor (+)
let move_left  = move_hor (-)

