%Reatardant Drop Matlab Script (Bernoullis theorem)

clear;
clc;

%Step Size,intialisation 
t_step=0.2;
t=0;

%Paramaterisation 
V_gallons=3000; %Volume Gallons 
V_m3=V_gallons/222; %Volume m^3
rho_retardant=1078.44; %Density of retardant
g = 9.81; %Gravitational constant

%Tank Dimensions 
r=1;    %Raduis Tank
l=(V_m3)/(pi*r^2);  %Height of Cylnider 
A_t= pi*r^2; %Area tank base
A_e=0.5; %cross sectional area of the exit
h = l;

%Bernoullis
Ptop = 0;
Pbot = 0;
del_Pinitial = Ptop - Pbot;   %Ptop-Pbot

h_initial=l*0.99; %height from top of retardant to tank exit
h=h_initial;
h_delta=0;

v_1initial=0; %velocity at top of tank
v_2_initial = sqrt((2*del_Pinitial)/(rho_retardant) + 2*g*h + v_1initial^2); %Benoullis 

m_dot=rho_retardant*A_e*v_2_initial;

i = 1
v_1(i)=v_1initial; %Velocity at top 
v_2(i)=v_2_initial; %velocity at bottom of tank
del_P(i)=del_Pinitial;
h_per(i) = h/h_initial;
for i = 2:9 %works with the current time step until i = 8
    t(i) = t(i-1)+t_step;

    del_h = (v_2(i-1)*A_e*t_step)/(A_t); %change in height 
    h(i) = h(i-1) - del_h; %new height
    h_per(i) = h(i)/l; %dimensionless h

    v_1(i) = del_h/t_step;  %Height at top
    v_2(i) = sqrt((2*del_P(i-1))/(rho_retardant) + 2*g*h(i) + v_1(i)^2);
    del_v = v_2(i)-v_1(i);

    Cp = 0.5*rho_retardant*(del_v)^2-rho_retardant*g*h(i); %Pressure variation with del 
    del_P(i) = Cp;

    Ptop(i) = Pbot + Cp; %Pbot always 0, Ptop = Cp. Reagrange from DelP = Ptop - Pbot.

    if Ptop(i) < 0 
        Ptop(i) = Ptop(i) - Cp; %Ball Park Estimate 

    else 
       Ptop(i) = Ptop(i) + Cp;
    end
   
    del_P(i) = del_P(i-1) + Ptop(i);
    m_dot(i)=rho_retardant*A_e*v_2(i);
end

hold on
plot (t,v_1)
plot (t,v_2)
plot (t, h_per)
hold off

legend('v1','v2','h/hintial')

% plot (t,Ptop)

