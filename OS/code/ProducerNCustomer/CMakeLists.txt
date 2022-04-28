cmake_minimum_required(VERSION 3.22)
project(ProducerNCustomer C)

set(CMAKE_C_STANDARD 99)

add_executable(ProducerNCustomer main.c customer.c)
