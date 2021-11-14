clc
clear
close all

Data = readtable("aircraft_items.csv");

mass=46692;
cg.x=3.15;
cg.y=1.51;
cg.z=1.99;

%new values after Boss-Extrude2 removed
cg_ans.x=2.62;
cg_ans.y=1.51;
cg_ans.z=1.04;


I.xx=125231.93;
I.xy=383.90;
I.xz=35109.97;
I.yx=I.xy;
I.yy=173711.08;
I.yz=-487.03;
I.zx=I.xz;
I.zy=I.yz;
I.zz=119209.42;

%I=[I.xx I.yx I.xz; I.yx I.yy I.yz; I.zx I.zy I.zz];

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

for i=1:1:height(Data)
    %Inertia stuff
    I.xx= I.xx - (Data{i,2} * ((Data{i,4}-cg.y)^2 + (Data{i,5}-cg.z)^2));
end

display(I.xx);