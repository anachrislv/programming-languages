let min_difference seq =
  let total_sum = List.fold_left (+) 0 seq in
  let n = List.length seq in
  let dp = Array.make_matrix n (total_sum + 1) false in

  (* Initialize dp array *)
  dp.(0).(0) <- true;
  dp.(0).(List.hd seq) <- true;

  for i = 1 to n - 1 do
    for j = 0 to total_sum do
      dp.(i).(j) <- dp.(i-1).(j) || (j >= List.nth seq i && dp.(i-1).(j - List.nth seq i))
    done;
  done;

  let min_diff = ref max_int in

  for j = 0 to total_sum do
    if dp.(n-1).(j) then
      min_diff := min !min_diff (abs (total_sum - 2 * j));
  done;

  !min_diff

let () =
  let n = read_int () in
  let sequence = Array.init n (fun _ -> read_int ()) in
  Printf.printf "Minimum difference: %d\n" (min_difference (Array.to_list sequence))
