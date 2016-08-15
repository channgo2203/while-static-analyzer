type label = int
type var = string

type binop =
  | Add | Sub | Mult

type expr =
  | Const of int
  | Unknown
  | Var of var
  | Binop of binop * expr * expr

type comp = Eq | Neq | Le | Lt

type test =
  | Comp of comp * expr * expr
  | And of test * test
  | Or of test * test
  | Not of test

type stmt =
  | Assign of label * var * expr
  | Skip of label
  | If of label * test * stmt * stmt
  | While of label * test *stmt
  | Seq of stmt * stmt

type program = stmt * label

(*********************************************************)
(* Computes of the set of variables present in a program *)
(*********************************************************)

module S = Set.Make (struct type t = var let compare = compare end)

let rec var_expr s = function
  | Const z -> s
  | Unknown -> s
  | Var x -> S.add x s
  | Binop (o,e1,e2) -> var_expr (var_expr s e1) e2

let rec var_test s = function
  | Comp (c,e1,e2) -> var_expr (var_expr s e1) e2
  | And (t1,t2) -> var_test (var_test s t1) t2
  | Or (t1,t2) -> var_test (var_test s t1) t2
  | Not t -> var_test s t

let rec var_stmt s = function
  | Skip l -> s
  | Assign (l,x,e) -> S.add x (var_expr s e)
  | If (l,t,b1,b2) -> var_test (var_stmt (var_stmt s b1) b2) t
  | While (l,t,b) -> var_test (var_stmt s b) t
  | Seq (i1,i2) -> var_stmt (var_stmt s i1) i2

let vars (p,l) = S.elements (var_stmt S.empty p)
