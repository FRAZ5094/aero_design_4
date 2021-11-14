clear;
clc;

V_gallons=3000;
V_m3=V_gallons/222;

<<<<<<< HEAD
r=0.9;
=======
r=1.467;
>>>>>>> 724f0b3b7eb796775019b82ec79e1da9fcd5d0c8

L=(V_m3)/(pi*r^2);

t_step=0.001;
t=0;

pressure_delta=0;

rho=1078.44;

A_t= pi*r^2;

A_e=0.5; %cross sectional area of the exit

v_1=0; %velocity at top of tank

h_initial=(2*r)*0.9; %height from top of retardant to tank exit
h=h_initial;

v_2_initial = sqrt((2*pressure_delta)/(rho) + 2*h(1) + v_1(1));

v_2=v_2_initial; %velocity at bottom of tank
m_dot=rho*A_e*v_2;

g=9.81;

i=1;

return

tic
while h(i)>=0 %0.01*h_initial 
    i=i+1;
    
<<<<<<< HEAD
    % A_t=surface_area_tank(r,L,h(i-1));
=======
    A_t=2 * sqrt(2*h(i-1)*r - h(i-1)^2) * L;
>>>>>>> 724f0b3b7eb796775019b82ec79e1da9fcd5d0c8
    
    h_delta = (v_2(i-1)*A_e*t_step)/(A_t); %change in height of liquid due to velocity of liquid coming out of tank over the timestep
    new_h=h(i-1)-h_delta;
    
    h(i) = new_h;
    
    t(i)=t(i-1)+t_step;
    
    if mod(t(i),1)<1e-3
        display(t(i));
    end
    
    v_1(i) = (h_delta)/t_step;
    
    v_2(i) = sqrt((2*pressure_delta)/(rho) + 2*h(i)*g + v_1(i)); %(3.1)
    
    m_dot(i)=rho*A_e*v_2(i);
end
toc

plot(t,m_dot);

fprintf("Time to empty tank: %f\n", t(length(t)));