@echo off
set stv=3.7.3.0
echo building version %stv%
IF EXIST support-tools-cs7-%stv%.zip del /Q /F support-tools-cs7-%stv%.zip
IF EXIST Populate\ElementCatalog.html rmdir /S /Q Populate
echo Exporting from svn
svn export -q http://www.nl.fatwire.com/svn/support/support-tools/trunk/cs/src/main/Populate/
echo Creating zip
cd Populate
"c:\Program Files\7-Zip\7z.exe" a -tZip "..\support-tools-cs7-%stv%.zip" *
cd ..
