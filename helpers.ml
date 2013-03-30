(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

(* Helpers 
 **********)

let (//) x y = (float_of_int x) /. (float_of_int y)

let width (w,h,p)  = w
let height (w,h,p) = h


(** Not enough command line arguments were given. *)
let not_enough_args = 2

(** No images were in the arg list *)
let no_images       = 1

(** Everything went fine *)
let success         = 0


