open Printf
open Scanf
open Array

type position = int * int
type node = { position : position; value : int; mutable children : node list }

let print_tree node =
  let rec print_node n =
    printf "Position: %d,%d, Value: %d\n" (fst n.position) (snd n.position) n.value;
    List.iter print_node n.children
  in
  print_node node

let find_neighbors (i, j) n =
  let neighbor_positions = [|-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1|] in
  let rows = n in
  let cols = if rows > 0 then n else 0 in
  let is_valid (dr, dc) =
    let new_r, new_c = i + dr, j + dc in
    0 <= new_r && new_r < rows && 0 <= new_c && new_c < cols
  in
  Array.to_list neighbor_positions |> List.filter is_valid |> List.map (fun (dr, dc) -> i + dr, j + dc)
  

let keep_possible neighbors value matrix visited =
  List.filter (fun (i, j) -> value > matrix.(i).(j) && not (List.mem (i, j) visited)) neighbors
  |> List.map (fun (i, j) -> { position = (i, j); value = matrix.(i).(j); children = [] })

let rec expand_tree current_node n matrix visited =
  visited := current_node.position :: !visited;
  let neighbors = find_neighbors current_node.position n in
  let possible_neighbors = keep_possible neighbors current_node.value matrix !visited in
  current_node.children <- possible_neighbors;
  List.iter (fun child -> expand_tree child n matrix (ref (!visited))) current_node.children

let bfs root n =
  let rec bfs_helper queue =
    match queue with
    | [] -> None
    | (current_node, path) :: rest ->
      if current_node.position = (n - 1, n - 1) then Some path
      else begin
        let new_paths = List.map (fun child -> child, path @ [child.position]) current_node.children in
        bfs_helper (rest @ new_paths)
      end
  in
  bfs_helper [(root, [root.position])]

let path_to_moves path =
  match path with
  | None -> None
  | Some p ->
    let rec to_directions acc = function
      | [] -> List.rev acc
      | [ _ ] -> List.rev acc
      | (r1, c1) :: (r2, c2) :: tl ->
        let direction =
          if r2 - r1 = -1 then "N"
          else if r2 - r1 = 1 then "S"
          else "" in
        let direction' =
          if c2 - c1 = -1 then direction ^ "W"
          else if c2 - c1 = 1 then direction ^ "E"
          else direction in
        to_directions (direction' :: acc) ((r2, c2) :: tl)
    in
    Some (Printf.sprintf "[%s]" (String.concat "," (to_directions [] p)))


let () =
  if Array.length Sys.argv <> 2 then begin
    printf "Wrong usage.\n";
    exit 1
  end;

  let filename = Sys.argv.(1) in
  let file = open_in filename in
  let n = int_of_string (input_line file) in
  
  let matrix = Array.make_matrix n n 0 in
  
  for i = 0 to n - 1 do
    let line = input_line file in
    let row = List.map int_of_string (String.split_on_char ' ' line) in
    Array.blit (Array.of_list row) 0 matrix.(i) 0 (List.length row);

  done;
  
  close_in file;
  
  

  let root = { position = (0, 0); value = matrix.(0).(0); children = [] } in
  let visited = ref [(0, 0)] in
  expand_tree root n matrix visited;
  let path = bfs root n in
  let path = path_to_moves path in

  match path with
  | Some p -> printf "%s\n" p
  | None -> printf "IMPOSSIBLE\n"
