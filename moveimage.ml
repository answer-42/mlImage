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

