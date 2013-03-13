(*
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sebastian.benque@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Sebastian Benque
*)

let error root e =
  print_endline ("Error: in directory: "^root)

let rec get_files_rec files dir =
  Array.concat 
    (Array.to_list 
      (Array.map
        (fun fn ->
          let path = Filename.concat dir fn in
          let is_dir = try Some (Sys.is_directory path)
                       with e -> error dir e; None in
          match is_dir with
          | Some true  -> 
              Array.append files (get_files_rec [| |] path)
          | Some false -> [| path |]
          | None -> [| |])
        (try Sys.readdir dir with e -> error dir e; [| |])))
    

(* Get a list of files/dirs, and returns image files recusively *)
let get_images l =
  (* Here we can add more accepted picture types *)
  let is_image x = List.exists (Filename.check_suffix x)
                      [".jpg"; ".JPG"; ".jpeg"; ".JPEG"] 
  in
  List.find_all is_image 
    (Array.to_list (Array.concat (List.map (get_files_rec [| |]) l)))


