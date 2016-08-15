# while-static-analyzer
An implementation of a simple static analyzer for While-like language. The syntax of the language is shown below.

S   : 	Stmt 			- Statements
a   : 	AExp			- Arithmetic expressions
x,y : 	Var			- Program variables
n   :		Num			- Number literals
b   :	 	BExp			- Boolean expressions


a :=  x
    | n
	 | a1 op_a2

b := 	true
	 | false
	 | not b
	 | b1 op_b b2
	 | a1 op_r a2	
	 
S := 	x = a; 
	 | x = b; 
	 | skip; 
	 | S1; S2; 
	 | if b { S1 } else { S2 }
	 | while b { S }

op_a := +, - , *, /, ...
op_r := >=, >, <=, <, ...
op_b := and, or, xor, ...
