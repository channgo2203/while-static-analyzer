(*
 *  This file is part of a simple static analyzer for the While language
 *  Copyright (c) Van Chan Ngo
 *  
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)


type mode = Parse 
	| Cfg 
	| Sign 
	| Interval
	| Liveness
	

let mode = ref Interval
(** path of the source code file *)
let target = ref ""

let args = [ 
  ("-parse", Arg.Unit (fun () -> mode := Parse) , "Print the program with labels");
  ("-cfg", Arg.Unit (fun () -> mode := Cfg) , "Print the control flow graph");
  ("-sign", Arg.Unit (fun () -> mode := Sign) , "Sign analysis");
  ("-interval", Arg.Unit (fun () -> mode := Interval) , "Interval analysis");
  ("-liveness", Arg.Unit (fun () -> mode := Liveness) , "Liveness analysis");
  (*("-reduce", Arg.Unit (fun () -> EnvAbstractionNotRelational.reduction := true) , "Reduction operator for non-relational environment abstractions");*)
]

let _ =
  if not !Sys.interactive then
    begin
      Arg.parse args (fun s -> target := s) "usage: analyse <prog>" ;
      try 
			match !mode with
	  	 	| Parse -> print_string (Print.print_program (Parse.parse !target))
	  	 	| Cfg -> Cfg.print_cfg (Parse.parse !target)
	  	 	| Sign ->
	      	let p = Parse.parse !target in
	      	let res = Sign.solve_and_print p in
				print_string (Print.print_program_with_res p res)
	  	 	| _ -> print_string "To be implemented.\n"
      with x -> Printf.printf "uncaught exception %s\n" (Printexc.to_string x) 
    end

