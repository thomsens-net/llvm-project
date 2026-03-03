@echo off

md ..\Build 2>nul && cd ..\Build

cmake -DLLVM_ENABLE_PROJECTS=clang -DLLVM_USE_CRT_DEBUG=MTd -DLLVM_USE_CRT_RELEASE=MT -G "Visual Studio 17 2022" -A x64 -Thost=x64 ..\llvm
