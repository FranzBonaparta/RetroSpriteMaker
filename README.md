# RetroSpriteMaker

Created by **Jojopov**  
License: [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html)  
2025
![Miniature](./miniature.png){width=75%}

## Introduction

**RetroSpriteMaker** is a tool that will help you draw sprites the retro way.
Draw your sprite then copy the grid created — no image files involved!
This tool keeps only what's essential: the color data of the drawing.

## 🛠 Materials required

- any code editor
- Linux or **Windows Vista and later**
- Love2D (for development or running the .love file)

## Application Installation

### Linux

Simply run the project using:

<code>./RetroSpriteMaker/</code>
Or, if you already have the .love file:

 <code>RetroSpriteMaker.love</code>

### Windows

You can build a Windows executable using the provided build script.

## 📦 Build & Deployment

A script named <code>build.sh</code> is included at the root of the repository. It generates both the .love archive and a standalone Windows <code>.exe</code>.

### On Linux

<code>chmod +x build.sh
./build.sh</code>

This will:

Package the contents of <code>src/</code> into a <code>RetroSpriteMaker.love</code> archive

Concatenate it with the Windows version of <code>love.exe</code>

Copy necessary DLLs to <code>build/windows/</code>

Create a ready-to-distribute executable for Windows

💡 You need to download and extract the Love2D Windows (32-bit) binaries in <code>tools/love-win32/</code>.

### Running on Windows

Once built, your executable is located at:

<code>build/windows/RetroSpriteMaker.exe</code> 
It can be run directly **without installing Love2D**.

## 🎨 Color Index Reference

Below is the mapping between the color indices (used in the output array) and their RGB values:

| Index | RGB            | Index | RGB            | Index | RGB            | Index | RGB            |
|-------|----------------|-------|----------------|-------|----------------|-------|----------------|
| 1     | 240,237,255    | 2     | 163,151,216    | 3     | 50,39,99       | 4     | 20,2,40        |
| 5     | 249,230,194    | 6     | 249,134,92     | 7     | 211,12,29      | 8     | 130,0,58       |
| 9     | 255,235,186    | 10    | 249,170,72     | 11    | 158,53,30      | 12    | 91,11,40       |
| 13    | 255,249,191    | 14    | 206,194,57     | 15    | 142,142,27     | 16    | 46,84,0        |
| 17    | 233,255,147    | 18    | 170,198,57     | 19    | 56,153,0       | 20    | 0,73,19        |
| 21    | 208,249,132    | 22    | 110,224,69     | 23    | 29,198,43      | 24    | 5,114,56       |
| 25    | 229,255,209    | 26    | 158,255,158    | 27    | 50,219,129     | 28    | 7,122,122      |
| 29    | 186,255,211    | 30    | 112,255,228    | 31    | 35,181,239     | 32    | 5,36,119       |
| 33    | 230,201,255    | 34    | 182,99,249     | 35    | 98,47,237      | 36    | 33,12,91       |
| 37    | 249,199,235    | 38    | 191,138,234    | 39    | 86,66,175      | 40    | 39,25,99       |
