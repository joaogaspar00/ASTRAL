% Gravitic force as function of heigth

function F_g = gravitic_force(position, VEHICLE, EARTH)


% Calculate gravitational force and acceleration
r = EARTH.R + position(3); % Distance from the center of the Earth

F_g = [0; 0; -(EARTH.G * EARTH.M * VEHICLE.M) / (r^2)]; % Gravitational force


end