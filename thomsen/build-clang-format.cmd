@echo off

cd /d C:\Workspace\Build

cmake --build . --target clang-format --config Release
