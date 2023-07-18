open Sast
open Ast

let compare_typ t1 t2 =
  match (t1, t2) with
  | Int, Int -> 0
  | Bool, Bool -> 0
  | Double, Double -> 0
  | Void, Void -> 0
  | String, String -> 0
  | Object s1, Object s2 -> String.compare s1 s2
  | _ -> compare t1 t2

let rec listcompare cmp l1 l2 =
  match (l1, l2) with
  | [], [] -> 0
  | [], _ :: _ -> -1
  | _ :: _, [] -> 1
  | x1 :: l1', x2 :: l2' -> (
      match cmp x1 x2 with 0 -> listcompare cmp l1' l2' | res -> res)

module FunSig = struct
  type t = string * typ list

  let compare (s1, ts1) (s2, ts2) =
    match String.compare s1 s2 with
    | 0 -> listcompare compare_typ ts1 ts2
    | c -> c
end

module FunSigMap = Map.Make (FunSig)
module StringMap = Map.Make (String)

exception Exception of string

(************************** check class def below ************************************)
let get_formals_type args =
  List.rev (List.fold_left (fun accu (typ, _id) -> typ :: accu) [] args)

(*add function signiture to the funMap*)
let check_funDef funMap = function
  | Fun fundef ->
      let key : FunSig.t = (fundef.id, get_formals_type fundef.args) in
      if FunSigMap.mem key funMap then
        raise (Exception ("Function " ^ fundef.id ^ " cannot be redefined."))
      else
        let funMap = FunSigMap.add key fundef funMap in
        funMap
  | _ -> funMap

let get_accControl e =
  match e with
  | Public -> "public"
  | Private -> "private"
  | Protect -> "protect"

(*creat field map for a given class*)
let check_class_field (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) input =
  match input with
  (* typ and e is unchecked here*)
  | FieldDef (acc_opt, f_opt, typ, id, _e) ->
      let accflag =
        match acc_opt with Some e -> get_accControl e | None -> "public"
      in
      
      (match f_opt with Some Static -> (* if static, check sfieldmap*)
        if StringMap.mem id sfieldmap then
            raise (Exception ("Field " ^ id ^ " cannot be redefined"))
        else
          let fieldmap' = StringMap.add id (accflag, "static", typ) fieldmap in
          let sfieldmap' = StringMap.add id (accflag, "static", typ) sfieldmap in
            (fieldmap',sfieldmap', methodmap, smethodmap, constructormap)
      | None ->                   (* if nonstatic, check fieldmap *) (*actually both nonstatic and static are in fieldmap; sfieldmap only has static*)
        if StringMap.mem id fieldmap then
          raise (Exception ("Field " ^ id ^ " cannot be redefined"))
        else 
          let fieldmap' = StringMap.add id (accflag, "nonstatic", typ) fieldmap in
            (fieldmap',sfieldmap, methodmap, smethodmap, constructormap))
  | _ -> raise (Exception "Expect a FieldDef, but someting else is provided")

(*creat method map for a given class*)
let check_class_method (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) input =
  match input with
  (* typ and e is unchecked here*)
  | MethodDef (acc_opt, f_opt, funDef) ->
      let accflag =
        match acc_opt with Some e -> get_accControl e | None -> "public"
      in
      let fflag = match f_opt with Some _ -> "static" | None -> "nonstatic" in
      let type_list = get_formals_type funDef.args in
      let _ = if List.length type_list = 0 && fflag = "nonstatic" then raise (Exception ("Need parameter 'self` in the method '" ^ funDef.id ^ "'")) in
        (match fflag with "nonstatic" ->    (* if nonstatic, then check in methodmap*)
          let key : FunSig.t =  (funDef.id, List.tl type_list) in                  
            if FunSigMap.mem key methodmap then
              raise
                (Exception
                  ("Method " ^ funDef.id ^ " ("
                  ^ String.concat ", "
                      (List.map string_of_type (get_formals_type funDef.args))
                  ^ ") cannot be redefined"))
            else 
              let methodmap' = FunSigMap.add key (accflag, fflag, funDef) methodmap in
                (fieldmap,sfieldmap, methodmap', smethodmap, constructormap)
        | "static" ->                       (* if static, then check in smethodmap*)
            let key : FunSig.t =  (funDef.id, type_list) in                  
            if FunSigMap.mem key smethodmap then
              raise
                (Exception
                  ("Method " ^ funDef.id ^ " ("
                  ^ String.concat ", "
                      (List.map string_of_type (get_formals_type funDef.args))
                  ^ ") cannot be redefined"))
            else 
              let methodmap' = FunSigMap.add key (accflag, fflag, funDef) methodmap in
              let smethodmap' = FunSigMap.add key (accflag, fflag, funDef) smethodmap in
                (fieldmap,sfieldmap, methodmap', smethodmap', constructormap)
        | _ -> raise (Exception ("Impossible field modifier '" ^ fflag ^ "'")))
  | _ -> raise (Exception "Expect a MethodDef, but someting else is provided")

(*creat constructor map for a given class*)
let check_class_constructor (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) input =
  match input with
  (* typ and e is unchecked here*)
  | ConstructorDef (typ, args, body) ->
      let key : FunSig.t = (string_of_type typ, get_formals_type args) in
      if FunSigMap.mem key constructormap then
        raise
          (Exception ("Method " ^ string_of_type typ ^ " cannot be redefined"))
      else
        let funDef : fundef = { ty = typ; id = string_of_type typ; args; body } in
        let constructormap' = FunSigMap.add key ("public", "nonstatic", funDef) constructormap in
          (fieldmap,sfieldmap, methodmap, smethodmap, constructormap')
  | _ ->
      raise (Exception "Expect a ConstructorDef, but someting else is provided")

(*creat filed, counstructor map, method map for a class body*)
let check_class_body body =
  let check_one (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) e =
    match e with
    | ConstructorDef _ ->
        check_class_constructor (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) e
    | FieldDef _ -> check_class_field (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) e
    | MethodDef _ -> check_class_method (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) e
  in
  List.fold_left check_one
    (StringMap.empty, StringMap.empty, FunSigMap.empty, FunSigMap.empty, FunSigMap.empty)
    body

(*creat all class's map, key: className :: value:(fieldMap, methodMap, constructorMap, classDef)*)
let check_classDef classMap = function
  | Class cdf ->
      (* let () = print_string ("Define class " ^ cdf.id ^ "\n") in *)
      if StringMap.mem cdf.id classMap then
        raise (Exception ("Class " ^ cdf.id ^ " cannot be redefined."))
      else
        let (fieldmap,sfieldmap, methodmap, smethodmap, constructormap) = check_class_body cdf.body in
        let classMap =
          StringMap.add cdf.id
          (fieldmap,sfieldmap, methodmap, smethodmap, constructormap, cdf)
            classMap
        in
        if FunSigMap.cardinal constructormap < 1 then
          raise (Exception ("No constructor has been defined for " ^ cdf.id))
        else classMap
  | _ -> classMap

(************************** check interface def below ************************************)
(*creat absMethodMap for given interface*)
let check_interface_absFunDef map (absfundef : absFunDef) =
  let key : FunSig.t = (absfundef.id, get_formals_type absfundef.args) in
  if FunSigMap.mem key map then
    raise
      (Exception ("Abstract function " ^ absfundef.id ^ " cannot be redefined."))
  else
    let fflag =
      match absfundef.fieldM with Some _ -> "static" | None -> "nonstatic"
    in
    FunSigMap.add key ("public", fflag, absfundef) map

(*creat absMethodMap for a interfaceBody*)
let check_interface_body body =
  List.fold_left check_interface_absFunDef FunSigMap.empty body

(*creat all interface's map. key: interfaceName :: value absMethodMap*)
let check_interfaceDef interfaceMap = function
  | Interface interdf ->
      if StringMap.mem interdf.id interfaceMap then
        raise (Exception ("Interface " ^ interdf.id ^ " cannot be redefined."))
      else
        let map = check_interface_body interdf.body in
        let interfaceMap =
          StringMap.add interdf.id (map, interdf) interfaceMap
        in
        interfaceMap
  | _ -> interfaceMap

(*********************this is a wapper to check class, interface and global functions***********************)
(* create interface map, function map, class map for program *)
let creatDefMaps program =
  let check_one (classMap, funMap, interfaceMap) e =
    match e with
    | Class _ ->
        let classMap' = check_classDef classMap e in
        (classMap', funMap, interfaceMap)
    | Fun _ ->
        let funMap' = check_funDef funMap e in
        (classMap, funMap', interfaceMap)
    | Interface _ ->
        let interfaceMap' = check_interfaceDef interfaceMap e in
        (classMap, funMap, interfaceMap')
    | _ -> (classMap, funMap, interfaceMap)
  in
  let classMap, funMap, interfaceMap =
    List.fold_left check_one
      (StringMap.empty, FunSigMap.empty, StringMap.empty)
      program
  in
  let _ = if (FunSigMap.mem ("main", []) funMap) then () else raise (Exception ("No main() function defined")) in
  (************************** check class extends class, implements interface ************************************)
  (*check if super class exist*)
  let check_class_father classdef =
    match classdef.father with
    | Some father -> StringMap.mem father classMap
    | None -> true
  in

  (********* check if the class has implemented all methods in the interface it implements*********)
  let rec check_if_absMethods_implemented (classdef : classdef)
      (interfacedef : string) =
    if not (StringMap.mem interfacedef interfaceMap) then
      raise (Exception ("Interfaces" ^ " of " ^ classdef.id ^ " undefined"))
    else
      let _,_, mMap,_, _, _ = StringMap.find classdef.id classMap
      and absMap, interfaceDef = StringMap.find interfacedef interfaceMap in
      let () = 
          FunSigMap.iter
            (fun key _value ->
              if not (FunSigMap.mem key mMap) then
                raise
                  (Exception
                    ("Function '" ^ fst key ^ "' in Interface '" ^ interfacedef
                    ^ "' is not defined in Class '" ^ classdef.id ^ "'"))
              else
                let md, s, _ = FunSigMap.find key mMap in
                if not (md = "public" && s = "nonstatic") then
                  raise
                    (Exception
                      (fst key ^ " of interface " ^ interfacedef
                      ^ " is not defined in class " ^ classdef.id)))
            absMap
      in (* also need to check if interfaces it extends are implemented in this class*)
        (match interfaceDef.extend_members  with 
          None -> ()
        | Some fathers -> List.iter (check_if_absMethods_implemented classdef) fathers)

  in
  (*check if interface that extended exist*)
  let check_class_interface classdef =
    match classdef.interface with
    | Some interfaces ->
        List.iter (check_if_absMethods_implemented classdef) interfaces
    | None -> ()
  in
  let check_class_inheritance _ (_,_,_, _, _, classdef) =
    let father = match classdef.father with Some name -> name | None -> "" in
    if not (check_class_father classdef) then
      raise
        (Exception ("Super class" ^ father ^ " of " ^ classdef.id ^ " undefined"))
    else check_class_interface classdef
  in
  let () = StringMap.iter check_class_inheritance classMap in

  (* check if all father is defined, and return unit*)

  (************************** check interface extends interface ************************************)
  (*check if interface that extended exist*)
  let check_interface_interface (interfaceDef : interfaceDef) =
    match interfaceDef.extend_members with
    | Some interfaces ->
        List.for_all
          (fun interface -> StringMap.mem interface interfaceMap)
          interfaces
    | None -> true
  in
  let check_interface_inheritance _ (_, interfaceDef) =
    if not (check_interface_interface interfaceDef) then
      raise (Exception ("Interfaces" ^ " of " ^ interfaceDef.id ^ " undefined"))
  in
  let () = StringMap.iter check_interface_inheritance interfaceMap in

  (************* Add built-in function into the funMap ****************)
  let add_builtin_fundef map
      ((return_type : typ), (fname : string), (formal_list_t : typ list)) =
    let argsList = List.map (fun typ -> (typ, "x")) formal_list_t in
    FunSigMap.add (fname, formal_list_t)
      { ty = return_type; id = fname; args = argsList; body = [] }
      map
  in
  let funMap =
    List.fold_left add_builtin_fundef funMap
      [
        (Void, "print", [ Int ]);
        (Void, "print", [ Bool ]);
        (Void, "print", [ Double ]);
        (Void, "print", [ String ]);
        (Void, "print", [ Object "Animal" ]);
        (* only for testing*)
        (Void, "print", [ IntList ]);
        (String, "charAt", [ String; Int ]);
      ]
  in
  (* let () = print_int (FunSigMap.cardinal funMap) in  *)
  (************* Now it's time to produce sast ****************)
  (************** Declare a global variable map******************)
  let globalvarMap = ref StringMap.empty in
  let add_funsig map acc =
    FunSigMap.fold (fun key value acum -> FunSigMap.add key value acum) map acc
  in
  (* add all entry of map ino acc*)
  (* build a global constructor map by iterating through the classMap, find all consMap, and integrate them into a global consMap*)
  let constructorMap =
    StringMap.fold
      (fun _key (_,_,_, _, consM, _) acc -> add_funsig consM acc)
      classMap FunSigMap.empty
  in
  let type_of_identifier s map =
    (* this function is to find the type of a variable, raise NotFound*)
    try StringMap.find s !map
    with Not_found -> raise (Failure ("undeclared identifier " ^ s))
  in
  let rec check_assign lvaluet rvaluet err =
    (*this function checks if type1 = type2*)
    match lvaluet with
    | Object s1 -> (
        match rvaluet with
        | Object s2 -> (
            let _, _,_, _, _, cdf =
              try StringMap.find s2 classMap
              with Not_found -> raise (Failure "Unknown Class instance")
            in
            if cdf.id = s1 then Void
            else
              match cdf.father with
              | Some super ->
                  let rt = Object super in
                  check_assign lvaluet rt err
              | None ->
                (* let _ = raise (Exception (s2)) in *)
                  raise
                    (Failure
                       ("Right side object instance is not " ^ s1 ^ " subclass"))
            )
        | _ ->
            raise (Failure "Assigning non object to a variable of object type"))
    | _ -> if lvaluet = rvaluet then Void else raise (Failure err)
  in
  let elemTy ty =
    match ty with
    | IntList -> Int
    | BoolList -> Bool
    | DoubleList -> Double
    | StringList -> String
    | ObjectList s -> Object s
    | _ -> raise (Exception "Not an array of proper type")
  in
  let rec expr e map (inclass : bool)=
    match e with
    | Literal l -> (Int, SLiteral l)
    | Dliteral s -> (Double, SDliteral s)
    | BoolLit b -> (Bool, SBoolLit b)
    | StringLiteral s -> (String, SStringLiteral s)
    | Id s -> (type_of_identifier s map, SId s) (******possible bug******)
    | Asn (e1, e2) as ex ->
        let lt, e1' = expr e1 map inclass and rt, e2' = expr e2 map inclass in
        let err =
          "illegal assignment " ^ string_of_type lt ^ " = " ^ string_of_type rt
          ^ " in " ^ string_of_expr ex
        in
        (check_assign lt rt err, SAsn ((rt, e1'), (rt, e2')))
    | Binop (e1, op, e2) as e ->
        let t1, e1' = expr e1 map inclass and t2, e2' = expr e2 map inclass in
        let same = t1 = t2 in
        let ty =
          match op with
          | (Add | Sub | Mult | Div) when same && t1 = Int -> Int
          | (Add | Sub | Mult | Div) when same && t1 = Double -> Double
          | (Equal | Neq) when same -> Bool
          | (Less | Leq | Greater | Geq) when same && (t1 = Int || t1 = Double)
            ->
              Bool
          | (And | Or) when same && t1 = Bool -> Bool
          | _ ->
              raise
                (Failure
                   ("illegal binary operator " ^ string_of_type t1 ^ " "
                  ^ string_of_op op ^ " " ^ string_of_type t2 ^ " in "
                  ^ string_of_expr e))
        in
        (ty, SBinop ((t1, e1'), op, (t2, e2')))
    | Unop (op, e) as ex ->
        let t, e' = expr e map inclass in
        let ty =
          match op with
          | Neg when t = Int || t = Double -> t
          | Not when t = Bool -> Bool
          | _ ->
              raise
                (Failure
                   ("illegal unary operator " ^ string_of_uop op
                  ^ string_of_type t ^ " in " ^ string_of_expr ex))
        in
        (ty, SUnop (op, (t, e')))
    | Access (e1, e2) -> (
        let rec find_field (key : string) cname =
          (*recursive function to find a field *)
          let fieldM', _,_,_, _, cdf = StringMap.find cname classMap in
          try StringMap.find key fieldM'
          with Not_found -> (
            match cdf.father with
            | Some fname -> find_field key fname
            | None -> raise (Failure ("Field " ^ key ^ " is undefined")))
        in
        let rec find_method key cname =
          (*recursive function to find a method*)
          let _,_, methodM', _,_, cdf = StringMap.find cname classMap in
          try FunSigMap.find key methodM'
          with Not_found -> (
            match cdf.father with
            | Some fname -> find_method key fname
            | None -> raise (Failure ("Function " ^ fst key ^ " is undefinedddd")))
        in
        let field_or_method e cname vname static =
          match e with
          | Id fieldname ->
              let accflag, fflag, ty = find_field fieldname cname in
              if inclass = false then
                if static = true then
                  if accflag = "public" && fflag = "static" then
                    (ty, SAccess ((Object cname, SId vname), (ty, SId fieldname)))
                  else raise (Failure ("Field " ^ fieldname ^ " is undefineddd"))
                else if accflag = "public" && fflag = "nonstatic" then
                  (ty, SAccess ((Object cname, SId vname), (ty, SId fieldname)))
                else raise (Failure ("Field " ^ fieldname ^ " is undefined1"))
              else 
                if static = true then
                  if fflag = "static" then
                    (ty, SAccess ((Object cname, SId vname), (ty, SId fieldname)))
                  else raise (Failure ("Field " ^ fieldname ^ " is undefined"))
                else if fflag = "nonstatic" then
                  (ty, SAccess ((Object cname, SId vname), (ty, SId fieldname)))
                else raise (Failure ("Field " ^ fieldname ^ " is undefined"))

          | Call (funcname, args) ->
              let args_types =
                List.rev
                  (List.fold_left
                     (fun acc e ->
                       let t', _e' = expr e map inclass in
                       t' :: acc)
                     [] args)
              in
              let key = (funcname, args_types) in
              let accflag, fflag, fdf = find_method key cname in
              if inclass = false then
                if static = true then
                  if accflag = "public" && fflag = "static" then
                    (fdf.ty, SAccess( (Object cname, SId vname),
                            (fdf.ty, SCall (funcname, List.rev (List.fold_left
                                                              (fun acc e -> expr e map inclass :: acc)
                                                              [] args)))))
                  else raise (Failure ("Function " ^ fst key ^ " is undefined"))
                else if accflag = "public" && fflag = "nonstatic" then
                    (fdf.ty, SAccess ( (Object cname, SId vname),
                            (fdf.ty, SCall (funcname, List.rev
                                                      (List.fold_left
                                                        (fun acc e -> expr e map inclass :: acc)
                                                        [] args)))))
                else raise (Failure ("Function " ^ fst key ^ " is undefined"))
              else (* if not in class, then everything can be access*)
                if static = true then
                  if fflag = "static" then
                    (fdf.ty, SAccess( (Object cname, SId vname),
                            (fdf.ty, SCall (funcname, List.rev (List.fold_left
                                                              (fun acc e -> expr e map inclass :: acc)
                                                              [] args)))))
                  else raise (Failure ("Function " ^ fst key ^ " is undefined"))
                else if fflag = "nonstatic" then
                    (fdf.ty, SAccess ( (Object cname, SId vname),
                            (fdf.ty, SCall (funcname, List.rev
                                                      (List.fold_left
                                                        (fun acc e -> expr e map inclass :: acc)
                                                        [] args)))))
                else raise (Failure ("Function " ^ fst key ^ " is undefined"))
          | Indexing (fieldname, _, _) -> 
               let accflag, fflag, ty = find_field fieldname cname in
              if inclass = false then
                if static = true then
                  if accflag = "public" && fflag = "static" then
                    let _ = map := StringMap.add fieldname ty !map in
                    let ty',sexpr' = expr e map inclass in
                      (ty', SAccess ((Object cname, SId vname), (ty',sexpr')))
                  else raise (Failure ("Field " ^ fieldname ^ " is undefined"))
                else if accflag = "public" && fflag = "nonstatic" then
                  let _ = map := StringMap.add fieldname ty !map in
                  let ty',sexpr' = expr e map inclass in
                    (ty', SAccess ((Object cname, SId vname), (ty',sexpr')))
                else raise (Failure ("Field " ^ fieldname ^ " is undefined1"))
              else 
                if static = true then
                  if fflag = "static" then
                    let _ = map := StringMap.add fieldname ty !map in
                    let ty',sexpr' = expr e map inclass in
                      (ty', SAccess ((Object cname, SId vname), (ty',sexpr')))
                  else raise (Failure ("Field " ^ fieldname ^ " is undefined"))
                else if fflag = "nonstatic" then
                  let _ = map := StringMap.add fieldname ty !map in
                  let ty',sexpr' = expr e map inclass in
                      (ty', SAccess ((Object cname, SId vname), (ty',sexpr')))
                else raise (Failure ("Field " ^ fieldname ^ " is undefined"))
          | _ -> raise (Failure "Expect Id/Call on right-hand side of Access")
        in
        match e1 with
        | Id n ->
            if StringMap.mem n classMap then
              (*if it's a class name rather than a var name*)
              field_or_method e2 n n true
            else
              let ty, _sexp = expr e1 map inclass in
              field_or_method e2 (string_of_type ty) n false
        | Indexing(id, _e1', None) -> 
            let ty, sexp = expr e1 map inclass in
              (match field_or_method e2 (string_of_type ty) id false with
                (ty', SAccess(_, sexp2)) -> (ty', SAccess((ty, sexp), sexp2))
              | _ -> raise (Failure "Expect an object type on left-hand side of Access"))
        | Access(_, _) -> 
            let ty, sexp = expr e1 map inclass in
              (match field_or_method e2 (string_of_type ty) "" false with
                (ty', SAccess(_, sexp2)) -> (ty', SAccess((ty, sexp), sexp2))
              | _ -> raise (Failure "Expect an object type on left-hand side of Access"))
              (* (ty, SAccess(expr e3 map inclass, expr e4 map inclass)) *)
        | _ -> raise (Failure "Expect an object type on left-hand side of Access"))
    | DefAsn (t, n, e) -> (
        (* cannot check duplicates because a local variable can have the same name as a global var*)
        match e with
        | Some e' ->
            let t1, e1 = expr e' map inclass in
            let err =
              "illegal assignment " ^ string_of_type t ^ " = "
              ^ string_of_type t1 ^ " in " ^ string_of_expr e'
            in
            let rt =
              try check_assign t t1 err
              with Failure _ ->
                raise (Failure (string_of_type t ^ string_of_type t1 ^  "DefAsn two sides doesn't match"))
            in
            if rt = Void then (
              (* equal to check_assign() *) (*type is determined bt the type on the right handside*)
              map := StringMap.add n t1 !map;
              (* print_int (StringMap.cardinal !globalvarMap); *)
              (Void, SDefAsn (t1, n, (t1, e1))))
            else
              raise
                (Exception
                   ("Expect " ^ string_of_type t ^ " but provide "
                  ^ string_of_type t1))
        | None ->
            map := StringMap.add n t !map;
            (Void, SDefAsn (t, n, (t, SNull))))
    | Call (name, args) ->
        let checked_args =
          List.rev
            (List.fold_left
               (fun acc e ->
                 let t', _e' = expr e map inclass in
                 t' :: acc)
               [] args)
        in
        let key = (name, checked_args) in
        if FunSigMap.mem key funMap then
          let fundef = FunSigMap.find key funMap in
          ( fundef.ty,
            SCall
              ( name,
                List.rev
                  (List.fold_left (fun acc e -> expr e map inclass :: acc) [] args) ) )
          (* in raise (Exception (List.iter (fun arg -> match arg with SId _ -> raise (Exception "SId case") | _ -> raise (Exception "Failed")) argslis))  *)
        else raise (Exception ("Function " ^ name ^ "() is undefined."))
    | NewExpr e -> (
        match e with
        | Call (name, args) ->
            let checked_args =
              List.rev
                (List.fold_left
                   (fun acc e ->
                     let t', _e' = expr e map inclass in
                     t' :: acc)
                   [] args)
            in
            let key = (name, checked_args) in
            if FunSigMap.mem key constructorMap then
              let _, _, fundef = FunSigMap.find key constructorMap in
              ( fundef.ty,
                SNewExpr
                  ( fundef.ty,
                    SCall
                      ( name,
                        List.rev
                          (List.fold_left
                             (fun acc e -> expr e map inclass :: acc)
                             [] args) ) ) )
            else raise (Exception ("Counstructor " ^ name ^ "() is undefined."))
        | _ -> raise (Exception "Function call is required after NEW keyword."))
    | Null -> (Void, SNull)
    | Super -> (Void, SSuper)
    | NewArray (ty, e) -> (
        let t', e' = expr e map inclass in
        match t' with
        | Int -> (
            match ty with
            | Int -> (IntList, SNewArray (ty, (t', e')))
            | Bool -> (BoolList, SNewArray (ty, (t', e')))
            | Double -> (DoubleList, SNewArray (ty, (t', e')))
            | String -> (StringList, SNewArray (ty, (t', e')))
            | Object s -> (ObjectList s, SNewArray (ty, (t', e')))
            | _ as s ->
                raise (Exception ("There is no array of" ^ string_of_type s)))
        | _ -> raise (Exception "Index must be integer."))
    | Noexpr -> (Void, SNoexpr)
    | Indexing (id, expl, expo) -> (
        match expl with
        | exp :: _exps -> (
            let t, e = expr exp map inclass and idtype, _ = expr (Id id) map inclass in
            match t with
            | Int -> (
                match expo with
                | Some expo' ->
                    let t1' = elemTy idtype and t2', _e2' = expr expo' map inclass in
                    (* let _ = raise (Exception (string_of_type t2')) in *)
                    ( check_assign t1' t2'
                        "Incompatible assignment of list element.",
                      SIndexing (id, (t, e), Some (expr expo' map inclass)) )
                | None -> (elemTy idtype, SIndexing (id, (t, e), None)))
            | _ -> raise (Exception "Index must be integer."))
        | _ -> raise (Exception "n dimension array not allowed"))
    | ParenExp e -> expr e map inclass
    | _ -> raise (Exception "wait for implementation")
  in

  (*****************This function is used to check if an expression produce a boolean value ***********)
  let check_bool_expr e map inclass =
    let t', e' = expr e map inclass
    and err = "expected Boolean expression in " ^ string_of_expr e in
    if t' != Bool then raise (Failure err) else (t', e')
  in
  (*****************This function is used to check statement excluding Return ***********)
  let rec check_stmt e map (fundef : fundef) (inclass : bool) =
    match e with
    | Expr e -> SExpr (expr e map inclass)
    | If (p, b1, b2) ->
        SIf
          ( check_bool_expr p map inclass,
            check_stmt b1 map fundef inclass,
            check_stmt b2 map fundef inclass)
    | For (e1, e2, e3, st) ->
        let res = expr e1 map inclass in
        SFor
          ( res ,
            check_bool_expr e2 map inclass,
            expr e3 map inclass,
            check_stmt st map fundef inclass)
    | While (p, s) -> SWhile (check_bool_expr p map inclass, check_stmt s map fundef inclass)
    | Block sl ->
        let rec check_stmt_list es map fundef inclass=
          match es with
          | [ (Return _ as s) ] -> [ check_stmt s map fundef inclass]
          | Return _ :: _ -> raise (Failure "nothing may follow a return")
          | Block sl :: ss ->
              check_stmt_list (sl @ ss) map fundef inclass(* Flatten blocks *)
          | s :: ss -> check_stmt s map fundef inclass :: check_stmt_list ss map fundef inclass
          | [] -> []
        in
        SBlock (check_stmt_list sl map fundef inclass)
    | ControlFlow cf -> SControlFlow cf
    | NoStmt -> SNoStmt
    | Return ex ->
        let t, e' = expr ex map inclass in
        if t = fundef.ty then SReturn (t, e')
        else
          raise
            (Failure
               ("return gives " ^ string_of_type t ^ " expected "
              ^ string_of_type fundef.ty ^ " in " ^ string_of_expr ex))
  in

  (*****************Check global statements***********)
  let check_global_stmt = function
    | Return _ -> raise (Exception "Cannot not return outside of a function.")
    | _ as s ->
        let empty_fundef = { ty = Void; id = "NIL"; args = []; body = [] } in
        SStmt (check_stmt s globalvarMap empty_fundef false)
  in

  let check_binds (kind : string) (to_check : bind list) =
    let name_compare (_, n1) (_, n2) = compare n1 n2 in
    let check_it checked binding =
      let void_err = "illegal void " ^ kind ^ " " ^ snd binding
      and dup_err = "duplicate " ^ kind ^ " " ^ snd binding in
      match binding with
      (* No void bindings *)
      | Void, _ -> raise (Failure void_err)
      | _, n1 -> (
          match checked with
          (* No duplicate bindings *)
          | (_, n2) :: _ when n1 = n2 -> raise (Failure dup_err)
          | _ -> binding :: checked)
    in

    let _ = List.fold_left check_it [] (List.sort name_compare to_check) in
    to_check
  in
  (**********check function body************)
  let check_function_implement (fundef : fundef) symbols (inclass : bool)=
    let funbody =
      List.rev
        (List.fold_left
           (fun acc e -> check_stmt e symbols fundef inclass :: acc)
           [] fundef.body)
    in
    (* let () = print_int (StringMap.cardinal !symbols) in *)
    (* let () = print_int (List.length funbody) in *)
    let fundef' : sfundef =
      { ty = fundef.ty; id = fundef.id; args = fundef.args; body = funbody }
    in
    SFun fundef'
  in
  (******** check a class's methods, constructor and field ********)
  let check_class_implement (cdf : classdef) =
    let class_stmts = cdf.body
    and fMap, _, _,_,_, _ = StringMap.find cdf.id classMap
    and globals' = !globalvarMap in
    let check_body_implement = function
      | MethodDef (acc, fm, fdf) -> (
          let args' = check_binds "local" fdf.args in
          let symbols_wt_f =
            List.fold_left
              (fun m (ty, name) -> StringMap.add name ty m)
              globals' args'
          in
          let symbols_w_f =
            StringMap.fold
              (fun key (_, _, ty) acc -> StringMap.add key ty acc)
              fMap symbols_wt_f
          in
          let symbols =
            match cdf.father with
            | None -> ref symbols_w_f
            | Some name ->
                let fMap, _,_,_, _, _ = StringMap.find name classMap in
                ref
                  (StringMap.fold
                     (fun key (_, _, ty) acc -> StringMap.add key ty acc)
                     fMap symbols_w_f)
          in
          let res = check_function_implement fdf symbols true in
          match res with
          | SFun sfdf -> SMethodDef (acc, fm, sfdf)
          | _ -> raise (Exception ("Errors in " ^ fdf.id ^ "'s body")))
      | ConstructorDef (t, binds, slist) -> (
          if
            not (string_of_type t = cdf.id)
            (**** check if constructor name is identical to class name ****)
          then
            raise
              (Exception
                 ("Constructor name is " ^ string_of_type t ^ ", but expect "
                ^ cdf.id))
          else
            let (fdf : fundef) =
              { ty = t; id = string_of_type t; args = binds; body = slist }
            in
            let args' = check_binds "local" fdf.args in
            let symbols_wt_f =
              List.fold_left
                (fun m (ty, name) -> StringMap.add name ty m)
                globals' args'
            in
            let symbols =
              ref
                (StringMap.fold
                   (fun key (_, _, ty) acc -> StringMap.add key ty acc)
                   fMap symbols_wt_f)
            in
            let res = check_function_implement fdf symbols true in
            match res with
            | SFun sfdf -> SConstructorDef sfdf
            | _ -> raise (Exception "ConstructorDef Error"))
      | FieldDef (acc, fmd, t, name, e) ->
          let symbols_w_f =
            StringMap.fold
              (fun key (_, _, ty) acc -> StringMap.add key ty acc)
              fMap globals'
          in
          let symbols =
            match cdf.father with
            | None -> ref symbols_w_f
            | Some name ->
                let fMap, _, _,_,_, _ = StringMap.find name classMap in
                ref
                  (StringMap.fold
                     (fun key (_, _, ty) acc -> StringMap.add key ty acc)
                     fMap symbols_w_f)
          in
          SFieldDef (acc, fmd, t, name, expr (DefAsn (t, name, e)) symbols true)
    in

    let body' = List.map check_body_implement class_stmts in
    let (scdf : sclassdef) =
      {
        id = cdf.id;
        father = cdf.father;
        interface = cdf.interface;
        body = body';
      }
    in
    SClass scdf
  in
  let check_all = function
    | Stmt e -> check_global_stmt e
    | Fun fundef ->
        let globals' = !globalvarMap in
        let args' = check_binds "local" fundef.args in
        let symbols =
          ref
            (List.fold_left
               (fun m (ty, name) -> StringMap.add name ty m)
               globals' args')
        in
        check_function_implement fundef symbols false
    | Class classdef -> check_class_implement classdef
    | Interface inter -> SInterface inter
  in
  (List.map check_all program, classMap)
