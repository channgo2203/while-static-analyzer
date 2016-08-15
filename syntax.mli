(** Syntax of programs *)

type label = int

type var = string

type binop = Add | Sub | Mult

type expr =
    Const of int
  | Unknown
  | Var of var
  | Binop of binop * expr * expr

type comp = Eq | Neq | Le | Lt

type test =
    Comp of comp * expr * expr
  | And of test * test
  | Or of test * test
  | Not of test
  
type stmt =
    Assign of label * var * expr
  | Skip of label
  | If of label * test * stmt * stmt
  | While of label * test * stmt
  | Seq of stmt * stmt
type program = stmt * label
 
(** [vars p] returns of the list of variables present in the program [p] *)
val vars : program -> var list
