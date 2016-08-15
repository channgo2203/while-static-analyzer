(** Syntax of programs *)

type label = int

type var = string

type binop = Add | Sub | Mult

type aexpr =
    Const of int
  | Unknown
  | Var of var
  | Binop of binop * expr * expr

type comp = Eq | Neq | Le | Lt

type bexpr =
  	 Comp of comp * aexpr * aexpr
  | And of bexpr * bexpr
  | Or of bexpr * bexpr
  | Not bexpr

type stmt =
    Assign of label * var * expr
  | Skip of label
  | If of label * bexpr * stmt * stmt
  | While of label * bexpr * stmt
  | Seq of stmt * stmt

type program = stmt * label
 
(** [vars p] returns of the list of variables present in the program [p] *)
val vars : program -> var list