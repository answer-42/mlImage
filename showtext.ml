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
let render_info state =
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
  Sdlvideo.blit_surface text state.screen ()

(* TODO render heptext *)
let render_help state = ()
(*
  let text = ["esc       Quit the program";
              "right     Next image";
              "left      Prev image";
              "a         Move image left";
              "d         Move image right";
              "s         Move image down";
              "w         Move image up";
              "i         Zoom in";
              "o         Zoom out";
              "f         Fit image";
              "z         Full image";
              "t         Show file name";
              "h         Show this help text";
              "n         Don't show any text"]
  in
  let rect = { Sdlvideo.r_x = 0;
               Sdlvideo.r_y = 0;
               Sdlvideo.r_w = 100;
               Sdlvideo.r_h = 400;
             }
  in
  (* Create the black canvas where we write the text on *)
  Sdlvideo.fill_rect ~rect:rect state.screen Int32.zero;
  (* Write the text on the canvas *)
  List.iter (fun x -> 
              let t = Sdlttf.render_text_solid state.font x ~fg:Sdlvideo.white in
              Sdlvideo.blit_surface t state.screen ())
            text
            *)
