@echo off

cd /d %~dp0

echo Make sure destination folder and file origin folder share the same name

set /p "file=Enter PNG name: "

set /p "dest=Enter destination folder: "


REM Make B&W Game Boy graphics
..\..\..\..\superfamiconv\superfamiconv.exe -v -i %dest%\%file%.png -t %file%.chr -m %file%.map -M gb

..\..\..\..\superfamiconv\superfamiconv.exe tiles -v -i %dest%\%file%.png -R -M gb -d %file%.chr

..\..\..\..\superfamiconv\superfamiconv.exe palette -v -i %dest%\%file%.png -d %file%.pal -M gbc -R

HV_RLE_Compression.py %file%.chr

move %file%Tiles.inc ..\%dest%\OBJ
move %file%.pal ..\%dest%\OBJ

del %file%.chr
del %file%.map

set /p "file=Press enter to exit "

