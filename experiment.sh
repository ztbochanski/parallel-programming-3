#!/bin/bash

CXX=clang++

SRC_FILE=mutex03.cpp
OUT_FILE=mutex03

for n in 1024 2048 4096 8192 16384 32768
do
  for m in true true true true true false false false false false false false false false false
  do
       $CXX -Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include -L/usr/local/opt/libomp/lib -lomp $SRC_FILE  -DNUMN=$n -DUSE_MUTEX=$m  -o $OUT_FILE
      ./$OUT_FILE
  done
done
