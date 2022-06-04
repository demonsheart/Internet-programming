cmake_minimum_required(VERSION 3.22)
project(code C)

set(CMAKE_C_STANDARD 11)

add_executable(schedule lab-2/schedule.c lab-3/hello-getc.c lab-3/alloc-memory.c lab-3/alloc-memory2.c lab-3/max-memory.c lab-3/alloc-memory-256-write.c lab-3/alloc-memory-256-read.c)