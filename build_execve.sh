#!/bin/bash

for dir in working/*; do
  nasm -g -f elf $dir/execve.asm
  ld -melf_i386 $dir/execve.o -o $dir/execve
done
