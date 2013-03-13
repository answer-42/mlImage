

(* Get a list of files/dirs, and returns image files recusively *)
let get_images l =
  (* Here we can add more accepted picture types *)
  let is_image x = List.exists (Filename.check_suffix x)
                      [".jpg"; ".JPG"; ".jpeg"; ".JPEG"] 
  in
  (* TODO At the moment it only takes pictures. Doesen't decent into the
   * directories recursively *)
  List.find_all is_image l


