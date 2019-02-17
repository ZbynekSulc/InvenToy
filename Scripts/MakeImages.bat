md images
FOR %%f in (*.scad)  DO "c:\program files\openscad\openscad.exe" -o "images\%%~nf.png" --render  --imgsize=1024,768 --projection=p  "%%f" 