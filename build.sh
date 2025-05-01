#!/bin/bash
# Create RetroSpriteMaker.love
cd src
zip -9 -r ../RetroSpriteMaker.love .
cd ..

# Create Windows folder
mkdir -p build/windows
cat tools/love-win32/love.exe RetroSpriteMaker.love > build/windows/RetroSpriteMaker.exe
cp tools/love-win32/*.dll build/windows/
cp tools/love-win32/license.txt build/windows/