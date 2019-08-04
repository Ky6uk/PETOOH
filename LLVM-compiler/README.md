# pthc – PETOOH compiler to LLVM IR (bitcode)

## Requirements

* C++14 compiler
* CMake
* LLVM 3.8 libraries

## Building

Run the following commands from the compiler root directory:

    mkdir build && cd build
    cmake ../
    make

## Usage

Produce LLVM bitcode file:

    ./pthc main.koko -o main.bc

To obtain human-readable LLVM assembly code one can use:

    llvm-dis main.bc -o main.ll

The bitcode file can be run by itself:

    lli main.bc

Or it can be compiled to an executable:

    llc main.bc -o main.s && gcc main.s -o main
