clc
clear
close all

load("sim.mat")
disp(out)

%%
close all

figure ()
plot(out.main_clock, out.vehicle_position, "LineWidth",1.5)
ylabel("P [m]")

figure ()
plot(out.main_clock, -out.vehicle_velocity, "LineWidth",1.5)
ylabel("V [/s]")

figure ()
plot(out.main_clock, out.rotor_velocity * 60 / (2*pi), "LineWidth",1.5)
ylabel("RPM")

figure ()
plot(out.main_clock, out.F_total, "LineWidth",1.5)
ylabel("F [N]")

figure ()
plot(out.main_clock, out.F_rotor, "LineWidth",1.5)
ylabel("F Rotor [N]")

figure ()
plot(out.main_clock, out.T_total, "LineWidth",1.5)
ylabel("T [N/m]")

figure ()
plot(out.main_clock, out.T_rotor, "LineWidth",1.5)
ylabel("T Rotor [N]")

