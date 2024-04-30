       
type node = {
  number : int;
  mutable left : node option;
  mutable right : node option;
  mutable parent : node option;
  mutable minimum : int; (* Using mutable field for simplicity *)
}


let print_node_info node =
  
  Printf.printf "Node number: %d\n" node.number;
  Printf.printf "Left child: %s\n"
    (match node.left with None -> "None" | Some l -> string_of_int l.number);
  Printf.printf "Right child: %s\n"
    (match node.right with None -> "None" | Some r -> string_of_int r.number);
  Printf.printf "Parent: %s\n"
    (match node.parent with None -> "None" | Some p -> string_of_int p.number);
  Printf.printf "Minimum: %d\n" node.minimum

let node_permutation node =
  match node with
  | None ->
      () 
  | Some n ->
      let temp = n.left in
      n.left <- n.right;
      n.right <- temp


let rec in_order_to_string_non_zero node =
  match node with
  | None ->
      ""
  | Some n ->
      let left_subtree = in_order_to_string_non_zero n.left in
      let this_node =
        if n.number <> 0 then string_of_int n.number ^ " " else ""
      in
      let right_subtree = in_order_to_string_non_zero n.right in
      left_subtree ^ this_node ^ right_subtree

let rec set_nodes_minimum node_pointer n =
  match node_pointer with
  | None -> 
      0 (* Return a default minimum value for None *)
  | Some node ->
      if node.number = 0 then (
        node.minimum <- n + 1;
        node.minimum
      )
      else if
        match (node.left, node.right) with
        | Some l, Some r -> l.number = 0 && r.number = 0
        | _ -> false
      then (
        node.minimum <- node.number;
        node.minimum)
      else
        let left_min = set_nodes_minimum node.left n in
        let right_min = set_nodes_minimum node.right n in
        let min_value = min (min left_min right_min) node.number in
        node.minimum <- min_value;
        min_value
        


let rec get_minimum_string node =
  match node with
  | None ->
      ()
  | Some n ->
      (match (n.left, n.right) with
      | Some l, Some r ->
          if l.number <> 0 then get_minimum_string n.left;
          if r.number <> 0 then get_minimum_string n.right;
          if l.number <> 0 || r.number <> 0 then (
            let left_min = l.minimum in
            let right_min = r.minimum in
            (* Printf.printf "Left: %d | Right: %d\n" left_min right_min; *)
            if l.number = 0 then begin
              (* Printf.printf "hello1\n"; *)
              if n.number > right_min then node_permutation node
              end
            else if r.number = 0 then begin
              (* Printf.printf "hello2\n"; *)
              if n.number < left_min then node_permutation node
              end
            else if left_min > right_min then begin
              (* Printf.printf "hello3\n"; *)
              node_permutation node
            end
              )
      | _ ->
          ()) ;;

                
let rec create_nodes file =
  let nodes = ref [] in
  let counter = ref 0 in
  let prev_node = ref None in

  let rec create_node value =
    let n = {
      number = value;
      left = None;
      right = None;
      parent = None;
      minimum = -1;
    } in

    nodes := !nodes @ [n];

    match !prev_node with
    | None -> prev_node := Some n 
    | Some p ->
        prev_node := Some n;
        n.parent <- Some p;
        if p.left = None then p.left <- Some n
        else p.right <- Some n

  in

  let rec update_prev_node node =
    match node with
    | None -> ()
    | Some n ->
        if n.number = 0 then (
          counter := !counter + 1;
          prev_node := n.parent;
          let rec find_parent_to_update p =
            match p with
            | None -> ()
            | Some parent ->
                if (parent.left <> None && parent.right <> None) && parent.parent <> None then (
                  prev_node := parent.parent;
                  find_parent_to_update !prev_node
                )
          in
          find_parent_to_update !prev_node
        )
  in

  let pre_process value = 
    create_node value;
    update_prev_node !prev_node
  in


  let values = input_line file |> Str.split (Str.regexp " ") |> List.map int_of_string in

  List.iter pre_process values;

  !nodes


let main () =
  if Array.length Sys.argv <> 2 then (
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0);
    exit 1
  );

  let filename = Sys.argv.(1) in
  let file = open_in filename in

  let n = int_of_string (input_line file) in

  (* Printf.printf "The value of N is: %d\n" n; *)

  let nodes = create_nodes file in
  close_in file;

  ignore (set_nodes_minimum ((Some (List.hd nodes))) n);

  (* List.iter (fun node ->
    print_node_info node;
    print_endline ""
  ) nodes; *)

  get_minimum_string (Some (List.hd nodes));

  let result = in_order_to_string_non_zero (Some (List.hd nodes)) in
  print_endline result
  


let () = main ()
