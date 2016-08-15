# while-static-analyzer
An implementation of a simple static analyzer for While-like language. The syntax of the language is shown below.

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

