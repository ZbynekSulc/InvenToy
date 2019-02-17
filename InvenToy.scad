/*
InvenToy - Library
====================
Autor:  Zbyněk Šulc
Datum:  7.2.2018
Verze:  
2.0 -   27.5.2017   - Prototype
3.0 -   7.2.2018    - 3D Rendering
4.0 -   13.2.2018   - 2D rendering mouch faster
5.0 -   21.2.2018   - Add const file 
*/
include <InvenToy_config.scad>;
include <InvenToy_const.scad>;


$fn=30;

module Strap(width, height, rc=4, t=Thikness)
{
    Strap2D(width, height, roundedCorners=rc, thikness=t);
}

module Strap2D(width, height, roundedCorners=4, thikness=Thikness)
{
    w=HolePitch*width;
    h=HolePitch*height;
    
   // translate([0, 0, -thikness/2]){     
        linear_extrude(height=thikness, scale=1, slices=20, twist=0){
        difference(){
            square([w, h]);
                // Holes
                for (x =[0:width-1])
                        for (y =[0:height-1])
                            translate([x*HolePitch+HolePitch/2, y*HolePitch+HolePitch/2, 0])
                                circle(d=Hole);
                    
            if(roundedCorners > 2)
                Corner2D();
                
            if(roundedCorners > 3)
                translate([0,height*HolePitch,0])
                    rotate(270)
                        Corner2D();
            
            if(roundedCorners > 0)
                translate([width*HolePitch,height*HolePitch,0])
                    rotate(180)
                        Corner2D();
            
            if(roundedCorners > 1)
                translate([width*HolePitch,0,0])
                    rotate(90)
                        Corner2D();        
            }
        }
   // }
}

module Corner2D()
{
    translate([HolePitch/2,HolePitch/2,0])
        rotate(180)
            difference()
            {
                square([HolePitch,HolePitch]);
                circle(d=HolePitch);
            }
}



module Strap3D(width, height, roundedCorners=4, thikness=Thikness)
{
	difference()
    {
        cube([width*HolePitch, height*HolePitch, thikness]);    
        for(w=[0:width-1])
            for(h=[0:height-1])
                translate([HolePitch/2+(w*HolePitch),h*HolePitch+HolePitch/2,0])
                    cylinder(d=Hole,h=Thikness);
            
        if(roundedCorners > 2)
            Corner3D();
            
        if(roundedCorners > 3)
            translate([0,height*HolePitch,0])
                rotate(270)
                    Corner3D();
        if(roundedCorners > 0)
            translate([width*HolePitch,height*HolePitch,0])
                rotate(180)
                    Corner3D();
        
        if(roundedCorners > 1)
            translate([width*HolePitch,0,0])
                rotate(90)
                    Corner3D();        
    }
}

module Corner3D()
{
    translate([HolePitch/2,HolePitch/2,0])
        rotate(180)
            difference()
            {
                cube([HolePitch,HolePitch,Thikness]);
                cylinder(d=HolePitch,h=Thikness);
            }
}

module Support(type = 0)
{
    if(type==0)
        for(a=[0:12])
            rotate(360/12*a)
                translate([-0.5/2,-0.5/2,0])
                    cube([HolePitch/2,0.5,RaftsThikness]);
    else
        cylinder(d=10, h=RaftsThikness);
}

module BaseStrap(width, height, roundedCorners=4, thikness=Thikness)
{
    Strap(width, height, roundedCorners, thikness);
    if(true){
    // Supports
        Support();        
    translate([width*HolePitch,0,0])
        Support();        
    translate([0,height*HolePitch,0])
        Support();
    translate([width*HolePitch,height*HolePitch,0])
        Support();
    }
}
//UBeam(1,5,1);
module Beam(width, height, depth, thikness=Thikness)
{
    BaseStrap(width, height,0,thikness);
    translate([0,0,2*thikness])
        rotate([0,-90,0])
            Strap(depth, height,2,thikness);
    
    // Addin
    translate([-thikness,0,0])
        cube([thikness,height*HolePitch,2*thikness]);
}

module UBeam(width, height, depth, thikness=Thikness)
{
    
    union(){
        /*Strap(width, height );
        rotate([0,-90,0])
            Strap(depth, height);
            */
            Beam(width, height, depth, thikness);
        translate([width*HolePitch+thikness,0,2*thikness])
            rotate([0,-90,0])
                Strap(depth, height, 2, thikness);
        
      // Addin
    translate([width*HolePitch,0,0])
        cube([thikness,height*HolePitch,2*thikness]); 
    }
}

module Stopper()
{
    difference(){
        union(){
            cylinder(d=8, h=8);
            
            translate([2,-3.5,0])
                cube([5,7,8]);
        }
        translate([5,0,4])
            rotate([0,90,0])
                cylinder(d=ScrewHole, h=10,center=true);

         translate([-5,0,4])
            rotate([0,90,0])
                cylinder(d=ScrewHole, h=10,center=true);
            
        cylinder(d=Hole, h=10);//
    }
}


module M2NutPocket()
{
    cube([5.4,5.4,2.5]);
}

module M3NutPocket()
{
    translate([-3/2,-6/2,0])
    cube([3,6.2,10]);
}
    
    
module NutStopper()
{
    difference(){
        union(){
            cylinder(d=10, h=8);
            
            translate([0,-5,0])
                cube([7,10,8]);
        }
        translate([5,0,4])
            rotate([0,90,0])
                cylinder(d=ScrewHole, h=10,center=true);

         translate([-5,0,4])
            rotate([0,90,0])
                cylinder(d=ScrewHole, h=10,center=true);
        translate([3.5,0,1])
            M3NutPocket();
            
        cylinder(d=Hole, h=10);// shaft hole
    }
        
}

PulleyRim = 1;
module Pulley(InnerDiameter, OuterDiameter, Thikness, withHoles=false)
{
        OR = OuterDiameter/2;
        IR = InnerDiameter/2;
        
     union(){
            cylinder(r1=OR,r2=OR,h=PulleyRim);

            translate([0,0,PulleyRim])
                cylinder(r1=OR,r2=IR,h=Thikness/2);

            translate([0,0,PulleyRim+Thikness/2])
                cylinder(r1=IR,r2=OR,h=Thikness/2);

            translate([0,0,PulleyRim+Thikness])
                cylinder(r1=OR,r2=OR,h=PulleyRim);
 
        } 
    }
module LitePulley(InnerDiameter, OuterDiameter, Thikness, withHoles=false)
{
    difference()
    {
       Pulley(InnerDiameter, OuterDiameter, Thikness, withHoles);
        translate([4,0,0]) // (Thikness+2*PulleyRim)-7 // ToDo: dodělat polohování kapsy
            M3NutPocket();
        translate([OuterDiameter/4,0,Thikness/2+PulleyRim])
            rotate([0,90,0])
                cylinder(d=ScrewHole, h=OuterDiameter/2,center=true);
        cylinder(d=Hole, h=Thikness+2*PulleyRim);//        
    }
}
module BigPulley(InnerDiameter, OuterDiameter, Thikness, withHoles=false)
{
    difference()
    {
        union(){
           Pulley(InnerDiameter, OuterDiameter, Thikness, withHoles);         translate([0,0,Thikness+2*PulleyRim])
                NutStopper();
        }
        
        if(withHoles){
            for(a=[0:8])
                rotate([0,0,a*(360/8)])
                    translate([0,10,0])
                        cylinder(d=Hole, h=Thikness+2*PulleyRim);
            for(a=[0:16])
                rotate([0,0,a*(360/16)])
                    translate([0,20,0])
                        cylinder(d=Hole, h=Thikness+2*PulleyRim);
        }
        cylinder(d=Hole, h=20);//
    }
}



//============= WaterMark ===============

WaterMarkHeight=0.5;
module WaterMark()
{
    if (IsWaterMark){
        translate([0,-4,WaterMarkHeight])
            rotate([0,180,0])
                Label("InvenToy",4);
        
        translate([0,4,WaterMarkHeight])
            rotate([0,180,0])
                Label("ZbynekSulc",2.8);
    }
}


module Label(txt,s)
{
    linear_extrude(height = WaterMarkHeight) {
        text(txt, size = s, font =  "Liberation Sans", halign = "center", valign = "center", $fn = 16);
    }      
}