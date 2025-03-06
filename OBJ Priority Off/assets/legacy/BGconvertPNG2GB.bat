@echo off

cd /d %~dp0

echo Make sure destination folder and file origin folder share the same name

set /p "file=Enter PNG name: "

set /p "dest=Enter destination folder: "


REM Make B&W Game Boy graphics
..\..\..\..\superfamiconv\superfamiconv.exe -i %dest%\%file%.png -t %file%.chr -m %file%.map -M gb

..\..\..\..\superfamiconv\superfamiconv.exe tiles -i %dest%\%file%.png -R -M gb -d %file%.chr

..\..\..\..\superfamiconv\superfamiconv.exe palette -i %dest%\%file%.png -d %file%.pal -M gbc -R

CGB2SGB_Pal.py %file%.pal

HV_RLE_Compression.py %file%.chr

HV_RLE_Compression.py %file%.map

move %file%Pal.inc ..\%dest%\BG
move %file%.pal ..\%dest%\BG
move %file%Tiles.inc ..\%dest%\BG
move %file%Map.inc ..\%dest%\BG

del %file%.chr
del %file%.map

set /p "file=Press enter to exit "