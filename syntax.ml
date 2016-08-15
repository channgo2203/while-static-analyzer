
type label = int
type var = string

type binop =
  | Add | Sub | Mult

type aexpr =
  | Const of int
  | Unknown
  | Var of var
  | Binop of binop * aexpr * aexpr

type comp = Eq | Neq | Le | Lt

type bexpr =
  | Comp of comp * aexpr * aexpr
  | And of bexpr * bexpr
  | Or of bexpr * bexpr
  | Not of bexpr

type stmt =
  | Assign of label * var * aexpr
  | Skip of label
  | If of label * bepxr * stmt * stmt
  | While of label * bexpr * stmt
  | Seq of stmt * stmt

type program = stmt * label


module S = Set.Make (struct type t = var let compare = compare end)

let rec var_aexpr s = function
  | Const z -> s
  | Unknown -> s
  | Var x -> S.add x s
  | Binop (o,e1,e2) -> var_aexpr (var_aexpr s e1) e2

let rec var_bexpr s = function
  | Comp (c,e1,e2) -> var_aexpr (var_aexpr s e1) e2
  | And (b1,b2) -> var_bexpr (var_bexpr s b1) b2
  | Or (b1,b2) -> var_bexpr (var_bexpr s b1) b2
  | Not b -> var_bexpr s b

let rec var_stmt s = function
  | Skip l -> s
  | Assign (l,x,e) -> S.add x (var_aexpr s e)
  | If (l,b,stm1,stm2) -> var_bexpr (var_stmt (var_stmt s stm1) stm2) b
  | While (l,b,stms) -> var_bexpr (var_stmt s stms) b
  | Seq (stm1,stm2) -> var_stmt (var_stmt s stm1) stm2

let vars (p,l) = S.elements (var_stmt S.empty p)
