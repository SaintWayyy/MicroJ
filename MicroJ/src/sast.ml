(* Semantically-checked Abstract Syntax Tree and functions for printing it *)

open Ast

type sexpr = typ * sx

and sx =
  | SLiteral of int
  | SDliteral of string
  | SBoolLit of bool
  | SStringLiteral of string
  | SId of string
  | SBinop of sexpr * op * sexpr
  | SUnop of uop * sexpr
  (* | SObjListDef of string * string list * string *)
  | SAccess of sexpr * sexpr
  | SObjMethod of typ * string * sexpr list
  (* | SObjDef of typ * string *)
  | SDefAsn of typ * string * sexpr
  (* | SPreDefAsn of typ * string * expr option *)
  (* | SObjDefAsn of typ * string * expr *)
  | SAsn of sexpr * sexpr
  (* | SObjAsn of string * expr *)
  | SCall of string * sexpr list
  | SListExpr of sexpr list option
  | SIndexing of string * sexpr * sexpr option
  | SParenExp of sexpr
  (* | SSetDim of expr list *)
  | SNewExpr of sexpr
  | SNewArray of typ * sexpr
  | SNull
  | SThis
  | SSuper
  | SNoexpr

type sstmt =
  | SBlock of sstmt list
  | SExpr of sexpr
  | SReturn of sexpr
  | SIf of sexpr * sstmt * sstmt
  | SFor of sexpr * sexpr * sexpr * sstmt
  | SWhile of sexpr * sstmt
  | SControlFlow of controlFlow
  | SNoStmt

type sfundef = {
  ty : typ;
  id : string;
  args : (typ * string) list;
  body : sstmt list;
}

type sclassStmt =
  | SConstructorDef of sfundef
  | SFieldDef of accControl option * fieldModifier option * typ * string * sexpr
  | SMethodDef of accControl option * fieldModifier option * sfundef

type sclassdef = {
  id : string;
  father : string option;
  interface : string list option;
  body : sclassStmt list;
}

type sabsFunDef = {
  fieldM : fieldModifier option;
  ty : typ;
  id : string;
  args : (typ * string) list;
}

type sinterfaceDef = {
  id : string;
  extend_members : string list option;
  body : sabsFunDef list;
}

type sprogramComp =
  | SStmt of sstmt
  | SFun of sfundef
  | SClass of sclassdef
  | SInterface of interfaceDef

type sprogram = sprogramComp list

(* Unparser function *)
let rec string_of_sexpr (t, e) =
  "(" ^ string_of_type t ^ " : "
  ^ (match e with
    | SLiteral l -> string_of_int l
    | SDliteral l -> l
    | SBoolLit true -> "true"
    | SBoolLit false -> "false"
    | SStringLiteral l -> l
    | SId l -> l
    | SBinop (e1, o, e2) ->
        string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
    | SUnop (o, e) -> string_of_uop o ^ string_of_sexpr e
    | SAccess (e1, e2) -> string_of_sexpr e1 ^ "." ^ string_of_sexpr e2
    | SObjMethod (name, meth, el) ->
        string_of_type name ^ "." ^ meth ^ "("
        ^ String.concat ", " (List.map string_of_sexpr el)
        ^ ")"
    | SAsn (e1, e2) -> string_of_sexpr e1 ^ " = " ^ string_of_sexpr e2
    | SCall (n, el) ->
        n ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
    | SListExpr el -> (
        match el with
        | Some lis ->
            "[" ^ String.concat ", " (List.map string_of_sexpr lis) ^ "]"
        | None -> "[]")
    | SIndexing (id, idx, exp) -> (
        id ^ string_of_sexpr idx
        ^ match exp with Some e -> " = " ^ string_of_sexpr e | None -> "")
    | SParenExp e -> "(" ^ string_of_sexpr e ^ ")"
    | SNewExpr e -> "new " ^ string_of_sexpr e
    | SDefAsn (ty, id, e) -> string_of_type ty ^ " " ^ id ^ string_of_sexpr e
    | SThis -> "this"
    | SNull -> "null"
    | SSuper -> "super"
    | SNewArray (t, e) ->
        "new " ^ string_of_type t ^ " [" ^ string_of_sexpr e ^ "]"
    | SNoexpr -> "")
  ^ ")"

let rec string_of_sstmt = function
  | SBlock stmts ->
      "{\n    "
      ^ String.concat "\n    " (List.map string_of_sstmt stmts)
      ^ "\n}"
  | SExpr expr -> string_of_sexpr expr ^ ";"
  | SReturn expr -> "return " ^ string_of_sexpr expr ^ ";"
  | SIf (e, s, SBlock []) ->
      "if (" ^ string_of_sexpr e ^ ") " ^ string_of_sstmt s
  | SIf (e, s1, s2) ->
      "if (" ^ string_of_sexpr e ^ ")\n" ^ string_of_sstmt s1 ^ " else "
      ^ string_of_sstmt s2 ^ "\n    "
  | SFor (e1, e2, e3, s) ->
      "for (" ^ string_of_sexpr e1 ^ " ; " ^ string_of_sexpr e2 ^ " ; "
      ^ string_of_sexpr e3 ^ ") " ^ string_of_sstmt s
  | SWhile (e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ string_of_sstmt s
  | SControlFlow Break -> "break;"
  | SControlFlow Continue -> "continue;"
  | SNoStmt -> ""

let string_of_sfundef (fd : sfundef) =
  string_of_type fd.ty ^ " " ^ fd.id ^ "("
  ^ String.concat ", "
      (List.map (function t, s -> string_of_type t ^ " " ^ s) fd.args)
  ^ ") {\n    "
  ^ String.concat "\n    " (List.map string_of_sstmt fd.body)
  ^ "\n}\n"

let string_of_sclassStmt = function
  | SConstructorDef sfundef ->
      "constructor " ^ string_of_type sfundef.ty ^ "("
      ^ String.concat ", "
          (List.map
             (function t, s -> string_of_type t ^ " " ^ s)
             sfundef.args)
      ^ ") {\n    "
      ^ String.concat "\n" (List.map string_of_sstmt sfundef.body)
      ^ ";\n}"
  | SFieldDef (ac, fm, t, s, e) ->
      string_of_ac ac ^ " " ^ string_of_fm fm ^ " " ^ string_of_type t ^ " " ^ s
      ^ " = " ^ string_of_sexpr e ^ ";"
      (* (match e with
         | Some exp -> string_of_ac ac ^ " " ^ string_of_fm fm ^ " " ^ string_of_type t ^ " " ^ s ^ " = " ^ string_of_sexpr exp ^ ";"
         | None -> string_of_ac ac ^ " " ^ string_of_fm fm ^ " " ^ string_of_type t ^ " " ^ s ^ ";") *)
  | SMethodDef (ac, fm, fd) ->
      string_of_ac ac ^ " " ^ string_of_fm fm ^ " " ^ string_of_sfundef fd

let string_of_sclassdef (cd : sclassdef) =
  "class " ^ cd.id ^ " " ^ string_of_father cd.father ^ " "
  ^ string_of_class_interface cd.interface
  ^ " {\n    "
  ^ String.concat "\n    " (List.map string_of_sclassStmt cd.body)
  ^ "\n}\n"

let string_of_sabsfundef (sabsfundef : sabsFunDef) =
  string_of_fm sabsfundef.fieldM
  ^ " "
  ^ string_of_type sabsfundef.ty
  ^ " " ^ sabsfundef.id ^ "("
  ^ String.concat ";\n"
      (List.map (function t, s -> string_of_type t ^ " " ^ s) sabsfundef.args)
  ^ ");"

let string_of_sinterfacedef sinterfacedef =
  "interface " ^ sinterfacedef.id ^ " "
  ^ string_of_abs_interface sinterfacedef.extend_members
  ^ " {\n    "
  ^ String.concat "\n   " (List.map string_of_sabsfundef sinterfacedef.body)
  ^ "\n}"

let string_of_sprogramcomp = function
  | SStmt s -> string_of_sstmt s
  | SFun f -> string_of_sfundef f
  | SClass c -> string_of_sclassdef c
  | SInterface i -> string_of_interfacedef i

let string_of_sprogram program =
  String.concat "\n" (List.map string_of_sprogramcomp program)
