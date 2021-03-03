@echo off

devenv LLVM.sln /build Release /project tools\clang\tools\clang-format\clang-format.vcxproj
