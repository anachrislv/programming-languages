open Printf

let calculate_fairness seq =
  let n = List.length seq in
  let sum = List.fold_left (+) 0 seq in
  let prefix_sums = Array.make (n + 1) 0 in
  for i = 1 to n do
    prefix_sums.(i) <- prefix_sums.(i - 1) + List.nth seq (i - 1)
  done;
  let rec min_difference i j min_diff =
    if j = n then min_diff
    else
      let current = prefix_sums.(j) - prefix_sums.(i) in
      let diff = abs (current - (sum - current)) in
      min_difference i (j + 1) (min min_diff diff)
  in
  let rec min_difference_for_all i min_diff =
    if i = n then min_diff
    else min_difference_for_all (i + 1) (min_difference i (i + 1) min_diff)
  in
  min_difference_for_all 0 max_int

let main () =
  let args = Array.to_list Sys.argv in
  match args with
  | [_; filename] ->
      let file = open_in filename in
      (try
         let n = int_of_string (input_line file) in
         let seq = List.map int_of_string (Str.split (Str.regexp " +") (input_line file)) in
         let result = calculate_fairness seq in
         printf "%d\n" result
       with
       | End_of_file -> close_in file; exit 1)
  | _ ->
      eprintf "Usage: %s <filename>\n" Sys.argv.(0);
      exit 1

let () = main ()
