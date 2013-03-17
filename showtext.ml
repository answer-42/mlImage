(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Batteries
open Imagetypes

let font_name = "DejaVuSansMono.ttf"

(** This function initalizes the fontsystem and returns the font that we will
 * use in subsequent calls to render fonts. Fonts will be added to the state. *)
let init_fonts = 
  Sdlttf.init ();
  Sdlttf.open_font font_name 20

(** Create surface containing the filename *)
(* TODO: Add white rect under the black text so that it can be read on every
 * image, also black ones.*)
let render_info state =
  Sdlttf.render_text_solid state.font 
                           state.image_list.(state.current_image_id) 
                           ~fg:Sdlvideo.black
   
