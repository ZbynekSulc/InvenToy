md models
FOR %%f in (*.scad)  DO "c:\program files\openscad\openscad.exe" -o "models\%%~nf.stl" "%%f" 