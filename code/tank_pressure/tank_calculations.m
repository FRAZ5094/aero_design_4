clear;
clc;

t_end=8; %simulation lasts 8 seconds
t=0:0.1:t_end; %create time array
rho=1078.44; %retardant density in kg/m3

for V_gallons=[3000,4000,5000] %loop over desired gallon values
    
    V=V_gallons/220; %convert gallons to m^3
    m_target=V*rho; %calculate mass of retardant
    
    g=9.81;
    v=g*t; %velocity over time due to gravity
    
    masses=[]; %empty array to store mass
    A=0:0.001:0.5; %testing values of area from 0 to 0.5 m^2
    for current_A=A %loop over values of area
        %current_A is the area that is being tested this loop
        m_dot= rho.*current_A.*v; %calculate m_dot for this current_A
        total_m=(1/2)*m_dot(length(m_dot))*t_end; %calculate total mass that left the tank with current_A by integrating m_dot
        %g is constant so total_m is linear over time, so can be found with the area of a triangle
        masses=[masses,total_m]; %append total_m for this current_A to an array
    end

    %algorithm to find the area for which the total mass through the exit is closest to m_target
    closest=inf; %initial value for closest to m_target
    for i=1:1:length(masses) % loop over all values of masses
        if abs(masses(i)-m_target)<closest %check if value at masses(i) is closer than closest
            closest=abs(masses(i)-m_target); %set new closest to current closest
            required_area=A(i); %save area for closest value
        end
    end
    %print to command window
    fprintf('%.0f gallons of retardant requires %.3f m2 area\n',V_gallons,required_area);
end
