let find_minimum_b n =
  let rec find_b b =
    if b > n - 1 then -1
    else
      let rec find_k k =
        let x = (int_of_float ((float_of_int b ** float_of_int k) -. 1.0)) / (b - 1) in
        if int_of_float (float_of_int b ** float_of_int (k - 1)) > n then find_b (b + 1)
        else if n mod x = 0 && n / x <= b - 1 then b
        else find_k (k + 1)
      in
      find_k 2
  in
  find_b 2

let read_numbers filename =
  let lines = ref [] in
  let chan = open_in filename in
  try
    ignore (input_line chan); (* Skip the first line *)
    while true do
      lines := input_line chan :: !lines
    done; []
  with End_of_file ->
    close_in chan;
    List.rev_map int_of_string !lines

let () =
  if Array.length Sys.argv <> 2 then
    Printf.printf "Usage: %s <input_filename>\n" Sys.argv.(0)
  else
    let input_filename = Sys.argv.(1) in
    let numbers = read_numbers input_filename in
    let bases = List.map find_minimum_b numbers in
    List.iter (Printf.printf "%d\n") bases
