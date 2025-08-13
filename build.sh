#!/bin/bash
# Create RetroSpriteMaker.love
set -e  # Stop on error

echo "🔧 Creating RetroSpriteMaker.love..."
zip -9 -r ../RetroSpriteMaker.love . -x ".git*" "*.DS_Store" "*~" "tools/*"
cd ..

# Create Windows folder
echo "📁 Creating build directory..."
mkdir -p build/windows
echo "📦 Creating RetroSpriteMaker.exe..."
cat tools/love-11.5-win32/love.exe RetroSpriteMaker.love > build/windows/RetroSpriteMaker.exe
echo "📄 Copying DLLs and license..."
cp tools/love-11.5-win32/*.dll build/windows/
cp tools/love-11.5-win32/license.txt build/windows/
echo "✅ Build completed! Output: build/windows/RetroSpriteMaker.exe"
