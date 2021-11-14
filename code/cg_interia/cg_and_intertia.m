clc
clear
close all
format long g
Data = readtable("aircraft_items.csv");

mass=48000;
cg.x=1.94;
cg.y=3.06;
cg.z=1.5;

%new values after Boss-Extrude2 removed
cg_ans.x=2.62;
cg_ans.y=1.51;
cg_ans.z=1.04;


I.xx=129812.5;
I.xy=383.90;
I.xz=35109.97;
I.yx=I.xy;
I.yy=173711.08;
I.yz=-487.03;
I.zx=I.xz;
I.zy=I.yz;
I.zz=119209.42;

I_ans.xx=78560.43;
I_ans.xy=547.69;
I_ans.xz=-2587.30;
I_ans.yx=I_ans.xy;
I_ans.yy=65865.38;
I_ans.yz=-195.13;
I_ans.zx=I_ans.xz;
I_ans.zy=I_ans.yz;
I_ans.zz=78560.43;


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

cg.x=cg_sum.x/mass;
cg.y=cg_sum.y/mass;
cg.z=cg_sum.z/mass;

cg.x=1;
cg.y=2.5;
cg.z=1.5;

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
    
    delta=(m/12)*(W^2 + H^2) + m*((delta_y)^2 + (delta_z)^2);
    I.xx= I.xx - delta;
end


%I=[I.xx I.yx I.xz; I.yx I.yy I.yz; I.zx I.zy I.zz];
%I_ans=[I_ans.xx I_ans.yx I_ans.xz; I_ans.yx I_ans.yy I_ans.yz; I_ans.zx I_ans.zy I_ans.zz];


I.xx

