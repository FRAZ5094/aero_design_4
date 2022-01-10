clc
clear
close all
format long g

tic %start timing run time

Data = readtable("aircraft_items.xlsx"); %import data from csv

mass=44225; %starting mass in kg

absoulute_cog_to_nose=13.8+1.81; %distance from note to the start of route, used to 

cg.x=absoulute_cog_to_nose+1.23; %starting cg x position
cg.y=0; %starting cg y position
cg.z=0; %starting cg z position

%starting moment of inertia tensor values
I_convert=1.3558179619; %slug*ft^2 to kg/m

%not sure what axis this is aligned to
I.xx=533965*I_convert;
I.xy=0*I_convert;
I.xz=59261*I_convert;
I.yx=I.xy;
I.yy=607525*I_convert;
I.yz=0*I_convert;
I.zx=I.xz;
I.zy=I.yz;
I.zz=1019696*I_convert;

%calculating new cg

cg_sum.x=mass*cg.x;
cg_sum.y=mass*cg.y;
cg_sum.z=mass*cg.z;

for i=1:1:height(Data)
    
    %take away object mass
    mass=mass - Data{i,2};
    
    cg_sum.x=cg_sum.x - (Data{i,2}*Data{i,3});
    cg_sum.y=cg_sum.y - (Data{i,2}*Data{i,4});
    cg_sum.z=cg_sum.z - (Data{i,2}*Data{i,5});
    
end

%new cg position
cg_new.x=cg_sum.x/mass;
cg_new.y=cg_sum.y/mass;
cg_new.z=cg_sum.z/mass;

%translate starting I to new cg

I.xx = I.xx - mass*((cg.y-cg_new.y)^2 + (cg.z-cg_new.z)^2);
I.yy = I.yy - mass*((cg.x-cg_new.x)^2 + (cg.z-cg_new.z)^2);
I.zz = I.zz - mass*((cg.x-cg_new.x)^2 + (cg.y-cg_new.y)^2);
I.xy = I.xy - mass*(cg.x-cg_new.x)*(cg.y-cg_new.y);
I.yz = I.yz - mass*(cg.y-cg_new.y)*(cg.z-cg_new.z);
I.xz = I.xz - mass*(cg.x-cg_new.x)*(cg.z-cg_new.z);

%find new I 

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
    
    %translate I to cg
    
    I.xx= I.xx - ((m/12)*(W^2 + H^2) + m*((delta_y)^2 + (delta_z)^2));
    I.yy= I.yy - ((m/12)*(L^2 + H^2) + m*((delta_x)^2 + (delta_z)^2));
    I.zz= I.zz - ((m/12)*(L^2 + W^2) + m*((delta_x)^2 + (delta_y)^2));
    I.xy= I.xy - m*delta_x*delta_y;
    I.yz= I.yz - m*delta_y*delta_z;
    I.xz= I.xz - m*delta_x*delta_z;
    
end

toc %stop timing run time

cg_new

I=[I.xx I.xy I.xz; I.xy I.yy I.yz; I.xz I.yz I.zz]
