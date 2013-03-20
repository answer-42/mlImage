(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Batteries
open Imagetypes

(* TODO implement help *)

let font_name = "DejaVuSansMono.ttf"

(** This function initalizes the fontsystem and returns the font that we will
 * use in subsequent calls to render fonts. Fonts will be added to the state. *)
let init_fonts = 
  Sdlttf.init ();
  Sdlttf.open_font font_name 20

(** Create surface containing the filename *)
let render_info state =
    if state.text = Info then 
      (* Create the text surface *)
      let text = Sdlttf.render_text_solid state.font 
                                          state.image_list.(state.current_image_id) 
                                          ~fg:Sdlvideo.white
      in
      (* Get the size of the resulting text *)
      let (w,h) = Sdlttf.size_text state.font
                                   state.image_list.(state.current_image_id)
      in
      (* Blip text on image *)
      let rect = { Sdlvideo.r_x = 0;
                   Sdlvideo.r_y = 0;
                   Sdlvideo.r_w = w;
                   Sdlvideo.r_h = h;
                 }
      in
      (* Create the black canvas where we write the text on *)
      Sdlvideo.fill_rect ~rect:rect state.screen Int32.zero;
      (* Write the text on the canvas *)
      Sdlvideo.blit_surface text state.screen ();
    
