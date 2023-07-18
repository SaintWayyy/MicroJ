%{
open Ast
%}

%token SEMI LPAREN RPAREN LBRACE RBRACE LSQUARE RSQUARE COMMA PLUS MINUS TIMES DIVIDE ASSIGN DOT CONSTRUCTOR COLUMN

%token NOT EQ NEQ LT LEQ GT GEQ AND OR
%token RETURN IF ELSE FOR WHILE INT BOOL DOUBLE VOID STRING BREAK CONTINUE INTLIST BOOLLIST DOUBLELIST STRINGLIST
%token CLASS INTERFACE NEW IMPLEMENTS EXTENDS IS PUBLIC PRIVATE PROTECT STATIC THIS NULL SETDIMENSION SUPER
%token <int> LITERAL
%token <bool> BLIT
%token <string> ID DLIT STRINGLIT
%token EOF

%start program
%type <Ast.program> program

%nonassoc NOELSE 
%nonassoc ELSE DEF
%right ASSIGN 
%left OR
%left AND
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT
%left DOT
%nonassoc CLASSNAME


%%

program:
    programComp_list EOF { List.rev $1 }

programComp_list:
    /* nothing */    { [] }
    | programComp_list programComp { $2 :: $1 }

programComp:
    stmt {Stmt $1}
    // stmt_list    {Stmt (List.rev $1)}
  | fundef       {Fun  ($1)}
  | classdef     {Class($1)}
  | interfacedef {Interface($1)}

fundef:
    typ ID LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
        {{  ty = $1;
            id = $2;
            args = List.rev $4;
            body = List.rev $7}}

formals_opt:
    /* nothing */ { [] }
  | formal_list   { $1 }

formal_list:
    typ ID                   { [($1,$2)]     }
  | formal_list COMMA typ ID { ($3,$4) :: $1 }

classdef:
    CLASS ID father_opt interface_opt LBRACE class_stmt_list RBRACE
        {{ id = $2;
           father =  $3; 
           interface = $4;
           body = List.rev $6;}}

father_opt:
      EXTENDS ID  {Some $2}
    | {None}

interface_opt:
      IMPLEMENTS id_list {Some (List.rev $2)}
    | {None}

id_list:
      ID      {[$1]}
    | id_list COMMA ID  {$3 :: $1}    

interfacedef:
    INTERFACE ID extend_mem_opt LBRACE absFundef_list RBRACE
        {{ 
           id = $2;
           extend_members = $3;
           body = List.rev $5;
        }}

extend_mem_opt:
    | EXTENDS id_list {Some (List.rev $2)}
    | {None}

absFundef_list:
      /* nothing */ {[]}
    | absFundef_list absFundef {$2 :: $1}

absFundef:
    fieldMod typ ID LPAREN formals_opt RPAREN SEMI
        {{  
            fieldM = $1;
            ty = $2;
            id = $3;
            args = List.rev $5;
        }}

class_stmt_list:
    /* nothing */         {[]}
    | class_stmt_list class_stmt {$2 :: $1}

class_stmt:
      CONSTRUCTOR typ LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
       {ConstructorDef ($2, List.rev $4, List.rev $7)}
    | accControl fieldMod fundef {MethodDef ($1, $2, $3)}
    | accControl fieldMod typ ID def_stmt SEMI {FieldDef ($1, $2, $3, $4, $5)}


accControl:
      PUBLIC  {Some Public}
    | PRIVATE {Some Private}
    | PROTECT {Some Protect}
    | {None}
    
fieldMod:
      STATIC  {Some Static}
    | {None}
/*
empty_square_list:
      LSQUARE RSQUARE   {["[]"]}
    | empty_square_list LSQUARE RSQUARE {"[]" :: $1}
*/

list_type:
    INT LSQUARE RSQUARE %prec NOT{IntList }
  | BOOL LSQUARE RSQUARE  %prec NOT{BoolList }
  | DOUBLE LSQUARE RSQUARE  %prec NOT{DoubleList }
  | STRING LSQUARE RSQUARE  %prec NOT{StringList }
  | ID LSQUARE RSQUARE %prec CLASSNAME{ObjectList ($1)}

single_type:
    INT  {Int}
  | BOOL {Bool}
  | DOUBLE {Double}
  | STRING {String}
  | ID %prec CLASSNAME{Object $1}

typ: 
    single_type {$1}
  | list_type {$1}
  | VOID {Void}

  
stmt_list:
    /* nothing */  { [] }
  | stmt_list stmt { $2 :: $1 }

controlFlow:
    BREAK    {Break}
  | CONTINUE {Continue}

stmt:
    expr SEMI                               { Expr $1}
  | RETURN expr_opt SEMI                    { Return $2}
  | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
  | LBRACE stmt_list RBRACE                 { Block(List.rev $2)    }
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7)        }
  | FOR LPAREN expr_opt SEMI expr SEMI expr_opt RPAREN stmt
                                            { For($3, $5, $7, $9)   }
  | WHILE LPAREN expr RPAREN stmt           { While($3, $5)         }
  | controlFlow SEMI                        { ControlFlow($1)}



expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

/* expr that can be used as an index */
index_expr:
    LITERAL          { Literal($1)            }
  | ID     %prec NOELSE          { Id($1)                 }
  | expr PLUS   expr { Binop($1, Add,   $3)   }
  | expr MINUS  expr { Binop($1, Sub,   $3)   }
  | expr TIMES  expr { Binop($1, Mult,  $3)   }
  | expr DIVIDE expr { Binop($1, Div,   $3)   }
  | expr DOT expr    { Access ($1, $3)        }
  // | typ  DOT expr    { StaticAccess($1, $3)   }
  | funcall {$1}
  | MINUS expr %prec NOT { Unop(Neg, $2)      }


funcall:
   ID LPAREN args_opt RPAREN { Call($1, $3)  }


/* expr about define and assign */
def_asn_expr:
    expr ASSIGN expr   { Asn($1, $3)            }
  | typ ID def_stmt { DefAsn($1, $2, $3)}


expr:
    THIS             {This}
  | SUPER            {Super}
  | index_expr       {$1}
  | DLIT	           { Dliteral($1)           }
  | BLIT             { BoolLit($1)            }
  | STRINGLIT        { StringLiteral($1)      }
  | NULL             { Null }
  | expr EQ     expr { Binop($1, Equal, $3)   }
  | expr NEQ    expr { Binop($1, Neq,   $3)   }
  | expr LT     expr { Binop($1, Less,  $3)   }
  | expr LEQ    expr { Binop($1, Leq,   $3)   }
  | expr GT     expr { Binop($1, Greater, $3) }
  | expr GEQ    expr { Binop($1, Geq,   $3)   }
  | expr AND    expr { Binop($1, And,   $3)   }
  | expr OR     expr { Binop($1, Or,    $3)   }
  | NOT expr         { Unop(Not, $2)          }
  | def_asn_expr     { $1 }
  | LPAREN expr RPAREN {ParenExp $2                   }
  | NEW funcall         { NewExpr($2) }
  //| LSQUARE expr_list_opt RSQUARE {ListExpr ($2)}
  | NEW single_type LSQUARE expr RSQUARE {NewArray($2, $4)}
  | ID square_list def_stmt {Indexing($1, List.rev $2, $3)}


square_list: 
   LSQUARE index_expr RSQUARE   {[$2]}
  | square_list LSQUARE index_expr RSQUARE {$3 :: $1}

/*
expr_list_opt:
    expr_list {Some $1}
    | {None}
    

expr_list:
      expr  {[$1]}
    | expr_list COMMA expr {$1 @ [$3]}
*/

/* optional define statement */
def_stmt:
    | COLUMN ASSIGN expr {Some $3}
    | {None}


args_opt:
    /* nothing */ { [] }
  | args_list  { List.rev $1 }


args_list:
    expr                    { [$1] }
  | args_list COMMA expr { $3 :: $1 }