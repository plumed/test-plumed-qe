#!/bin/bash

for testDir in test_Si test_H2O; do

  cd "${testDir}" || exit

  pw.x -plumed <md.in >md.out

  for file in *.reference; do
    new="${file%.reference}"
    if test -f "$new"; then
      cp "$new" "$new.zfix"
      DIFFOPT=""
      out="$(diff "$DIFFOPT" "$file" "$new.zfix")"
      test -n "$out" && {
        echo FAILURE
        echo "Diff for ${file%.reference}:"
        echo "$out"
        exit 1
      }
    else
      echo FAILURE
      echo "FILE $new does not exist"
      exit 1
    fi
  done

  cd ../
done
