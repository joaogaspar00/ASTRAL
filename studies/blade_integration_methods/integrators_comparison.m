clc
clear
close all

x = linspace(0,2,41);
% y = x.^7;

y = exp(x.^2);

val = 16.4526277;



figure
plot(x,y)

boole_val = abs((boole_integration(x, y)-val)/val)*100
simpson_val = abs((simpson_integration(x, y)-val)/val)*100
rec_val = abs((rectangle_integration(x, y)-val)/val)*100
trap_val = abs((trapezoidal_integration(x, y)-val)/val)*100