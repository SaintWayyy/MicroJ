dune clean
dune build
_build/default/src/toplevel.exe -a "./test/$1" > "Result.ast" 
_build/default/src/toplevel.exe -s "./test/$1" > "Result.sast" 
_build/default/src/toplevel.exe -l "./test/$1" > "Result.ll"
llc -relocation-model=pic "Result.ll" > "Result.s"
cc -o "Result.exe" "Result.s"
"./Result.exe" 