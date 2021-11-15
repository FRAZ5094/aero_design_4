clc
clear
close all
format long g
Data = readtable("aircraft_items.csv");

mass=36000;
cg.x=2.75;
cg.y=1.875;
cg.z=1;

%new values after Boss-Extrude2 removed


I.xx=60937.5;
I.xy=16875;
I.xz=0;
I.yx=I.xy;
I.yy=87750;
I.yz=0;
I.zx=I.xz;
I.zy=I.yz;
I.zz=124687.5;



%calculating new center of mass

cg_sum.x=mass*cg.x;
cg_sum.y=mass*cg.y;
cg_sum.z=mass*cg.z;

for i=1:1:height(Data)
    
    %cg stuff
    mass=mass - Data{i,2};
    cg_sum.x=cg_sum.x - (Data{i,2}*Data{i,3});
    cg_sum.y=cg_sum.y - (Data{i,2}*Data{i,4});
    cg_sum.z=cg_sum.z - (Data{i,2}*Data{i,5});
end

cg_new.x=cg_sum.x/mass;
cg_new.y=cg_sum.y/mass;
cg_new.z=cg_sum.z/mass;

%find I at the new cg

% - because we are taking away the mass
I.xx = I.xx - mass*((cg.y-cg_new.y)^2 + (cg.z-cg_new.z)^2);
I.yy = I.yy - mass*((cg.x-cg_new.x)^2 + (cg.z-cg_new.z)^2);
I.zz = I.zz - mass*((cg.x-cg_new.x)^2 + (cg.y-cg_new.y)^2);

I.xy= I.xy - mass*(cg.x-cg_new.x)*(cg.y-cg_new.y);
I.yz= I.yz - mass*(cg.y-cg_new.y)*(cg.z-cg_new.z);
I.xz= I.xz - mass*(cg.x-cg_new.x)*(cg.z-cg_new.z);


for i=1:1:height(Data)
    %relative distances between objects cg and airplane cg
    delta_x=cg.x-Data{i,3};
    delta_y=cg.y-Data{i,4};
    delta_z=cg.z-Data{i,5};
    
    x_g=Data{i,3};
    y_g=Data{i,4};
    z_g=Data{i,5};
    
    m=Data{i,2};
    L=Data{i,6};
    W=Data{i,7};
    H=Data{i,8};
    
    
    I.xx= I.xx - ((m/12)*(W^2 + H^2) + m*((delta_y)^2 + (delta_z)^2));
    I.yy= I.yy - ((m/12)*(L^2 + H^2) + m*((delta_x)^2 + (delta_z)^2));
    I.zz= I.zz - ((m/12)*(L^2 + W^2) + m*((delta_x)^2 + (delta_y)^2));
    
    I.xy= I.xy - m*delta_x*delta_y;
    I.yz= I.yz - m*delta_y*delta_z;
    I.xz= I.xz - m*delta_x*delta_z;
end


I=[I.xx I.xy I.xz; I.xy I.yy I.yz; I.xz I.yz I.zz]




