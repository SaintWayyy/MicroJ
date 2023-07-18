(* Ocamllex scanner for MicroJ *)

{ open Parser }

let digit = ['0' - '9']
let digits = digit+

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
(* | "//"     { comment lexbuf }  *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| '['      { LSQUARE }
| ']'      { RSQUARE }
| ';'      { SEMI   }
| ':'      { COLUMN }
| ','      { COMMA  }
| '.'      { DOT    }

(* binOp *)
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '='      { ASSIGN }
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| "&&"     { AND }
| "||"     { OR }

(* unOp *)
| "!"      { NOT }

(* reserved keywords *)
| "if"     { IF }
| "else"   { ELSE }
| "for"    { FOR }
| "while"  { WHILE }
| "return" { RETURN }
| "public" { PUBLIC }
| "private" { PRIVATE }
| "protect" { PROTECT }
| "static" { STATIC } 
| "null"   {NULL}
| "break" { BREAK }
| "continue" { CONTINUE }

(* reserved type keywords *)
| "int"    { INT }
| "bool"   { BOOL }
| "double"  { DOUBLE }
| "string" { STRING }
(* | "int[]"    { INTLIST }
| "bool[]"   { BOOLLIST }
| "double[]"  { DOUBLELIST }
| "string[]" { STRINGLIST } *)
| "void"   { VOID }
| "true"   { BLIT(true)  }
| "false"  { BLIT(false) }

(* OOP reserved keywords *)
| "class" { CLASS }
| "interface" { INTERFACE }
| "constructor" {CONSTRUCTOR }
| "super"   { SUPER }
| "new" { NEW }
| "implements" { IMPLEMENTS }
| "extends" { EXTENDS }
| "is" { IS }
| "this" {THIS}

(* Literal *)
| digits as lxm { LITERAL(int_of_string lxm) }
| digits '.'  digit* as lxm { DLIT(lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| '\"' [^'\"']* '\"' as lxm  {STRINGLIT(lxm)}

(* end file and edge case *)
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
(* | '\n' { token lexbuf } *)
| eof  { token lexbuf }
| _    { comment lexbuf }
