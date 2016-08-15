
module Make =
  functor (L:Lattice.S) ->
struct
  
  module M = Map.Make(struct type t = string let compare = compare end)

  type t = L.t M.t
      
  let update env x v = M.add x v env
  let get env x = M.find x env

  let order_dec = M.equal L.order_dec
  
  let join x y =
    try
      M.mapi 
	(fun key v -> L.join v (M.find key y))
	x
    with Not_found -> assert false

  let meet x y =
    try
      M.mapi 
	(fun key v -> L.meet v (M.find key y))
	x
    with Not_found -> assert false

  let widen x y =
    try
      M.mapi 
	(fun key v -> L.widen v (M.find key y))
	x
    with Not_found -> assert false
    
  let narrow x y =
    try
      M.mapi 
	(fun key v -> L.narrow v (M.find key y))
	x
    with Not_found -> assert false
  
  let vars = ref ([]:string list)

  let init l_vars =
    vars := l_vars

  let bottom () =
    List.fold_right
      (fun key m -> M.add key (L.bottom ()) m)
      !vars
      M.empty

  let top () =
    List.fold_right
      (fun key m -> M.add key (L.top ()) m)
      !vars
      M.empty

  let to_string env =
    M.fold
      (fun key v s -> 
	 let x = L.to_string v in
	   if x = L.to_string (L.top ()) then s 
	   else Printf.sprintf "%s:%s  %s" key x s)
      env ""

end
  
