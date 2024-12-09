function update_progressBar(height, thrust_force, rotor_position, VEHICLE, rotorIsOpen)

global sim_data
global progress_bar

% Update progress bar
elapsed_time = toc;        
% Convert elapsed time to hours, minutes, and seconds
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = round(mod(elapsed_time, 60));
progress = 1 - height / VEHICLE.InitPosition(3);

if rotorIsOpen
    waitbar(progress, progress_bar, sprintf('Deployed - %.2f m | T = %.2f N | %.0f RPM \n %02d:%02d:%02d', height, thrust_force, rotor_position* 180/pi, fix(hours), fix(minutes), fix(seconds)));

else
    waitbar(progress, progress_bar, sprintf('Rotor off -  %.2f m \n %02dh:%02dm:%02ds', height, hours, minutes, seconds));
end


end