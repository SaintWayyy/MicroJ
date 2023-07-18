#!/bin/bash

# If a filename is passed as an argument, test only that file.
# Otherwise, test all files.
if [ $# -eq 1 ]; then
    files=("$1")
else
    files=("FailTest1" "FailTest2" "FailTest3" "FailTest4" 
           "Test1" "Test2" "Test3" "Test4" "Test5" "Test6" "Test7" "Test8" "Test9" "Test10"
           "Test11" "Test12" "Test13" "Test14" "Test15" "Test16" "Test17" "Test18" "Test19" "Test20"
           "Test21" "Test22" "Test23" "Test24" "Test25" "Test26" "Test27" "Test28" "Test29" "Test30"
           "Test31" "Test32" "Test33" "Test34" "Test35" "Test36" "Test37" "Test38" "Test39" "Test40"
           "Test41" "Test42" "Test43" "Test44" "Test45" "Test46" "Test47" "Test48" "Test49")
fi

# Test each file in the array.
dune clean
dune build
for f in "${files[@]}"; do
    if [[ "$f" == FailTest* ]]; then
        expected_output="./test/$f.out"
        actual_output=$(_build/default/src/toplevel.exe -l "./test/$f" 2>&1 )
        if [[ "$actual_output" != "$(cat $expected_output)" ]]; then
            echo "Failed Test failed as expected: $f"
        else
            echo "Failed Test did not fail as expected: $f"
        fi
    elif [[ "$f" == Test* ]]; then
        expected_output="./test/$f.out"
        _build/default/src/toplevel.exe -l "./test/$f" > "Result.ll"
        llc -relocation-model=pic "Result.ll" > "Result.s"
        cc -o "Result.exe" "Result.s"
        actual_output=$(./Result.exe)
        if [[ "$actual_output" != "$(cat $expected_output)" ]]; then
            echo "---Test failed: $f---"
        else
            echo "Test passed: $f"
        fi
    fi
done