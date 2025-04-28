function update_progressBar(VEHICLE, ROTOR)

global progress_bar

% Update progress bar
elapsed_time = toc;     

% Convert elapsed time to hours, minutes, and seconds
hours = floor(elapsed_time / 3600);
minutes = floor(mod(elapsed_time, 3600) / 60);
seconds = round(mod(elapsed_time, 60));
progress = 1 - VEHICLE.position(3) / VEHICLE.InitPosition(3);

if ROTOR.rotorIsOpen
    waitbar(progress, progress_bar, sprintf('Deployed - %.2f m | %.2f RPM\n %02d:%02d:%02d', VEHICLE.position(3), ROTOR.velocity*60/(2*pi), fix(hours), fix(minutes), fix(seconds)));

else
    waitbar(progress, progress_bar, sprintf('Rotor off -  %.2f m \n %02dh:%02dm:%02ds', VEHICLE.position(3), hours, minutes, seconds));
end


end