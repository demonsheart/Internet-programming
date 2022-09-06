cmake_minimum_required(VERSION 3.22)
project(TinyFileSys C)

set(CMAKE_C_STANDARD 99)

add_executable(TinyFileSys main.c assign100MB.c fileSys.h)
