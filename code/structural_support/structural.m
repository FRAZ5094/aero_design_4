%Beam tank calculation
clc
clf
%element data
length1=2060;
height1=270;
length2=200;
height2=1170;
length3=200;
height3=1170;
thickness=200;
%area of each element
area1=length1*height1;
area2=length2*height2;
area3=length3*height3;
atotal=area1+area2+area3;

%individual cg values
ycg1=height1/2;
ycg2=height1+(height2/3);
ycg3=height1+(height3/3);
xcg1=(length1/2)+200;
xcg2=length2/2;
xcg3=(length3/2)+200+2000;
%total cg
ycg=((area1*ycg1)+(area2*ycg2)+(area3*ycg3))/atotal;
xcg=1200;
%2nd moments of inertia
inertia1=(((1/12)*length1^3*height1)+(area1*(xcg1-xcg)));
inertia2=(((1/12)*length2^3*height2)+(area2*(xcg2-xcg)));
inertia3=(((1/12)*length3^3*height3)+(area3*(xcg3-xcg)));

totalInertia=inertia1+inertia2+inertia3;

%tank data
length=6550;
F=(16623*9.81)/length;
supports=4;
sections=supports-1;
momentLength=0;
loadLength=0;


%Resultants
Ry=(F*length)/supports;

%Moment
Mmax=(Ry*length)-((F*length^2)*(4/18));

%stress positive downwards (compression)
ZEtop=totalInertia/(height2-ycg);
ZEbottom=totalInertia/(0-ycg);

stressTop=Mmax/ZEtop;
stressBottom=Mmax/ZEbottom;

totalweight=0.1*2710*(atotal*10^-6);
%total load with 0.1m thick alauminium
totalLoad=(stressBottom*(length1+length2+length3)*(thickness))/1000;
%plotting stress at top/bottom
%stress in compression at top
%stress in tension at bottom
x=[stressTop,stressBottom];
y=[height2,0];
xconstant=[0,0];
yconstant=[ycg,ycg];
hold on
%plot stress distribution
plot(x,y);
plot(x,yconstant,'--');
plot(xconstant,y);
hold off
ylabel('Height (mm)');
xlabel('Stress (N/mm^2)');
title('Stress distribution through tank supports')
txt = 'Compression';
t=text(0.035,900,txt);
t.FontSize=24;

txt2 = 'Tension';
m=text(-.018,100,txt2);
m.FontSize=24;