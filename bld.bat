@echo off
cl /DINTRINSICS /nologo /O2 /Os /Fa /GS- /c threefish.c
jwasm -nologo -bin threefish.asm
cl /nologo test.c threefish.obj
del *.obj
dir *.bin