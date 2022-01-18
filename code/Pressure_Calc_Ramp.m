%Aero Design pressurised tank, With max angle of attack

clear;
clc;

t_step=0.001;
t=0;

%Volume/Dimensions
V_gallons=3000;
V_m3=V_gallons/222;
rho=1078.44; %densitiy of retardant 
alpha = 15; %angle of attack
alpha_r = alpha*pi/180;
g = cos(alpha_r)*9.81;

r=1; %Raduis of Tank
H=(V_m3)/(pi*r^2); %Height of tank
A_t= pi*r^2; %Area of tank

A_e=0.55; %cross sectional area of the exit
r_e = sqrt(A_e/pi); %Raduis of exit

%Pressure initialization
Ptop = 0;
Pbot = 0;
pressure_delta=Ptop - Pbot; %input pressure - pressure at exit


%Initial conditions. 
v_1=0; %velocity at top of tank
v_2_initial = sqrt((2*pressure_delta)/(rho) + 2*g*H + v_1(1));
v_2=v_2_initial; %velocity at bottom of tank

m_dot=rho*A_e*v_2;
h=H;
i=1;
while h(i)>=0.01*H 
    %Time step
    i=i+1;
    t(i)=t(i-1)+t_step;
    %New height
    h_delta = (v_2(i-1)*A_e*t_step)/(A_t); %change in height of liquid due to velocity of liquid coming out of tank over the timestep
    new_h=h(i-1)-h_delta;
    h(i) = new_h;
    h_per(i) = new_h/H;
    
    %Velocities 
    v_1(i) = (h_delta)/t_step;
    v_2(i) = sqrt((2*pressure_delta(i-1))/(rho) + 2*h(i) + v_1(i)); %(3.1)
    
    m_dot(i)=rho*A_e*v_2(i);

    Ptop(i)= Ptop(i-1)+0.565; %rough value to keep v_2 constant
    pressure_delta(i) = Ptop(i);
end

Pramp = Ptop(end)/t(end);
Ptot = Ptop(end)*t(end)*0.5;

tiledlayout(2,2)

% %Top Plot 
 nexttile
 plot(t,m_dot)
title ('mdot')
 xlabel('t(s)')
ylabel('mdot(kg/m^3)')

 nexttile 
 plot(t,h_per)
 title('h/h_initial')
xlabel('t(s)')
 ylabel('h/h_initial ')

 nexttile
 hold on
 plot (t,v_2)
 plot(t,v_1)
 title('v2')
xlabel('t(s)')
 ylabel ('velocity(m/s)')
 hold off
 legend('v_2','v_1')

 nexttile
 plot (t,Ptop)
 title('Input pressure')
xlabel('t(s)')
 ylabel('input pressure (Pa)')


fprintf("Time to empty tank: %f\n", t(length(t)));