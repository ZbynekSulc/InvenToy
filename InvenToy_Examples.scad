/*
InvenToy Library - Examples
====================
Autor:  Zbynek Šulc
Datum:  12.2.2018
Verze:  3.0


*/
include <InvenToy.scad>;

/*
    E X A M P L E S
*/

if(true)
    translate([0,0,0])
        Strap(1,5);

if(true)
    translate([20,0,0])
        BaseStrap(5,7);

if(true)
    translate([90,0,0])
        Strap(5,5);


if(true)
    translate([-20,0,0])
        Beam(1,10,1);

if(true)
    translate([-70,0,0])
        UBeam(3,5,1);

if(true)
    translate([0,-30,0])
        Stopper();


if(true)
    translate([30,-20,0])
        difference(){
            //Pulley(54,60,3.5,true);
            //Pulley(20,24,5);
            BigPulley(20,25,3.5,false);
            WaterMark();
        }
        


if(true)
    translate([-30,-20,0])
        difference(){
            LitePulley(20,25,6,false);
            WaterMark();
        }
