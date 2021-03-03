@echo off

cmake -DLLVM_ENABLE_PROJECTS=clang -DLLVM_USE_CRT_DEBUG=MTd -DLLVM_USE_CRT_RELEASE=MT -G "Visual Studio 15 2017" -A x64 -Thost=x64 ..\llvm