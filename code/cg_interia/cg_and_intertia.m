clc
clear
close all
format long g
Data = readtable("aircraft_items.csv"); %import data from csv

mass=30000;
cg.x=2.5;
cg.y=1.5;
cg.z=1;

I.xx=32500;
I.xy=0;
I.xz=0;
I.yx=I.xy;
I.yy=72500;
I.yz=0;
I.zx=I.xz;
I.zy=I.yz;
I.zz=85000;


%calculating new center of mass pos

cg_sum.x=mass*cg.x;
cg_sum.y=mass*cg.y;
cg_sum.z=mass*cg.z;

for i=1:1:height(Data)
    mass=mass - Data{i,2};
    
    cg_sum.x=cg_sum.x - (Data{i,2}*Data{i,3});
    cg_sum.y=cg_sum.y - (Data{i,2}*Data{i,4});
    cg_sum.z=cg_sum.z - (Data{i,2}*Data{i,5});
end

cg_new.x=cg_sum.x/mass;
cg_new.y=cg_sum.y/mass;
cg_new.z=cg_sum.z/mass;

%find I at the new cg

I.xx = I.xx - mass*((cg.y-cg_new.y)^2 + (cg.z-cg_new.z)^2);
I.yy = I.yy - mass*((cg.x-cg_new.x)^2 + (cg.z-cg_new.z)^2);
I.zz = I.zz - mass*((cg.x-cg_new.x)^2 + (cg.y-cg_new.y)^2);
I.xy = I.xy - mass*(cg.x-cg_new.x)*(cg.y-cg_new.y);
I.yz = I.yz - mass*(cg.y-cg_new.y)*(cg.z-cg_new.z);
I.xz = I.xz - mass*(cg.x-cg_new.x)*(cg.z-cg_new.z);


for i=1:1:height(Data)
    
    %relative distances between objects cg and airplane cg
    delta_x=cg.x-Data{i,3};
    delta_y=cg.y-Data{i,4};
    delta_z=cg.z-Data{i,5};
    
    %object values from data
    m=Data{i,2};
    
    %dimension along x axis
    L=Data{i,6};
    
    %dimension along y axis
    W=Data{i,7};
    
    %dimension along z axis
    H=Data{i,8};
    
    %calculate new I when object is removed
    I.xx= I.xx - ((m/12)*(W^2 + H^2) + m*((delta_y)^2 + (delta_z)^2));
    I.yy= I.yy - ((m/12)*(L^2 + H^2) + m*((delta_x)^2 + (delta_z)^2));
    I.zz= I.zz - ((m/12)*(L^2 + W^2) + m*((delta_x)^2 + (delta_y)^2));
    I.xy= I.xy - m*delta_x*delta_y;
    I.yz= I.yz - m*delta_y*delta_z;
    I.xz= I.xz - m*delta_x*delta_z;
end

cg_new
I=[I.xx I.xy I.xz; I.xy I.yy I.yz; I.xz I.yz I.zz]
