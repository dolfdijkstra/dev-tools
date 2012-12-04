@echo off
set stv=3.7.3.1
echo building version %stv%
IF EXIST support-tools-cs7-%stv%.zip del /Q /F support-tools-cs7-%stv%.zip
IF EXIST Populate\ElementCatalog.html rmdir /S /Q Populate
svn copy -m "Creating tag support-tools-cs7-%stv%" http://www.nl.fatwire.com/svn/support/support-tools/trunk/cs/src/main/Populate/ http://www.nl.fatwire.com/svn/support/support-tools/tags/support-tools-cs7-%stv%
echo Exporting from svn
svn export -q http://www.nl.fatwire.com/svn/support/support-tools/tags/support-tools-cs7-%stv% Populate
echo Creating zip
cd Populate
"c:\Program Files\7-Zip\7z.exe" a -tZip "..\support-tools-cs7-%stv%.zip" *
cd ..

"c:\Program Files\PuTTY\pscp.exe" "support-tools-cs7-%stv%.zip" "d670-1:/var/www/html/dta/support-tools/"
