{
  open Lexing 
  open While_parser
  
  exception Stop

  let kwd_tab = Hashtbl.create 23 

  let _ = 
    Hashtbl.add kwd_tab "while" WHILE;
    Hashtbl.add kwd_tab "for" FOR;
    Hashtbl.add kwd_tab "skip" SKIP;
    Hashtbl.add kwd_tab "assert" ASSERT;
    Hashtbl.add kwd_tab "ensure" ENSURE;
    Hashtbl.add kwd_tab "if" IF;
    Hashtbl.add kwd_tab "else" ELSE;
    Hashtbl.add kwd_tab "not" NOT;
    Hashtbl.add kwd_tab "and" AND;
    Hashtbl.add kwd_tab "or" OR

  let id_or_kwd s = 
    try Hashtbl.find kwd_tab s 
    with Not_found -> IDENT(s) 

  let level = ref 0

  let currentline = ref 1
}


let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = letter (letter | digit | '_' | '.')*
let integer = ['0'-'9']+
let float = integer '.' ['0'-'9']*
let space = [' ' '\t']

rule nexttoken = parse
    space+  { nexttoken lexbuf }
  | '\n'    { incr currentline; nexttoken lexbuf }
  | "(*"    { level := 1; comment lexbuf }
  | '#'[^'\n']*['\n'] {nexttoken  lexbuf}
  | ident   { id_or_kwd (lexeme lexbuf) }
  | '{'     { LB }
  | '}'     { RB }
  | '('     { LP }
  | ')'     { RP }
  | "=="    { EQ }
  | "<>"    { NEQ }
  | "<="    { LE }
  | '<'     { LT }
  | ">="    { GE }
  | '>'     { GT }
  | ';'     { PVL }
  | '+'     { ADD }
  | '-'     { SUB }
  | '*'     { MULT }
  | '='     { ASSIGN }
  | ','     { VL }
  | '?'     { UNKNOWN }
  | '.'     { PT }
  | ':'     { PTPT }
  | "//"    { comment' lexbuf }
  | integer { INT (int_of_string (lexeme lexbuf)) }
  | eof     { EOF }

and comment = parse
  | "*)"    { level := !level - 1; 
              if !level = 0 then nexttoken lexbuf 
	      else comment lexbuf }
  | "(*"    { level := !level + 1; comment lexbuf }
  | _       { comment lexbuf }

and comment' = parse
  | '\n'    { incr currentline; nexttoken lexbuf }
  | _       { comment' lexbuf }

{
  (* pour faire des test sur le lexer *)
  let list_token file =
    if not (Sys.file_exists file) then
      failwith  ("le fichier "^file^" n'existe pas\n")
    else
      let buf = from_channel (open_in file) in
      let rec aux () =
	try
	  match (nexttoken buf) with
	      EOF -> []
	    | t -> t::(aux ())
	  with Failure _ -> 
	    print_string "aucun moyen de filtrer le token courant !"; []
      in aux ()

}
