
cls

set INCLUDE="F:\GoAsm\Include"

64tass.exe -L evo816.txt -a -b -f -C -I ".\inc816" -i evo816.asm -o evo816.bin


rem GoRC /r "evoIcon.rc"
GoRC /fo "evoIcon.obj" "evoIcon.rc"
GoAsm61.exe /l /b /c /nw evo.asm
rem GoLink /debug coff /unused "evo.obj" evoIcon.obj d3d9.dll D3DX9_43.dll
GoLink /unused "evo.obj" evoIcon.obj d3d9.dll D3DX9_43.dll
