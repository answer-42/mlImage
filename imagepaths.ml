(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

open Batteries

let error root e =
  print_endline ("Error: in directory: "^root)

let rec get_files_rec files dir =
  Array.fold_right 
    (fun fn a -> Array.append
          (let path = Filename.concat dir fn in
           let is_dir = try Some (Sys.is_directory path)
                        with e -> error dir e; None in
           match is_dir with
           | Some true  -> 
               Array.append files (get_files_rec [| |] path)
           | Some false -> [| path |]
           | None -> [| |])
          a)
        (try Sys.readdir dir with e -> error dir e; [| |])
        [| |]

(* Here we can add more accepted picture types 
 * TODO: Use magic library *)
let is_image x = List.exists (Filename.check_suffix x)
                   [".jpg"; ".JPG"; ".jpeg"; ".JPEG"] 
 
(* Get a list of files/dirs, and returns image files recusively *)
let get_images l =
  (Array.fold_right 
        (fun e a -> flip Array.append a @@ get_files_rec [| |] e) l [| |])
  |> Array.find_all is_image 

