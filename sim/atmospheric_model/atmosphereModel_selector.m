function [ATMOSPHERE] = atmosphereModel_selector(TIME, SIM, VEHICLE)

    if strcmp(SIM.atmosphereModelSelector, 'EAM')
        
        [T,a,p,rho,nu, mu] =  EAM_atmospheric_model(VEHICLE.position(3));
        

    elseif strcmp(SIM.atmosphereModelSelector, 'ISA')

        [T,a,p,rho,nu, mu] = ISA_atmospheric_model(VEHICLE.position(3));

    elseif strcmp(SIM.atmosphereModelSelector, 'NRLMSISE-00')

        [T,a,p,rho,nu, mu] = NRLMSISE00_atmos_model(VEHICLE.position(3));


    else
        error("Simulation Error: Selected atmosphere model is not valid");
    end
   
    if TIME.clock >= 15 %&& TIME.clock <= 17
        ATMOSPHERE.wind_velocity = [0; 0; 0];
    else
        ATMOSPHERE.wind_velocity = [0; 0; 0];
    end

    ATMOSPHERE.wind_velocity = [0; 0; 0];
    
    ATMOSPHERE.temperature = T;
    ATMOSPHERE.pressure = p;
    ATMOSPHERE.density = rho;
    ATMOSPHERE.dynamic_viscosity = mu;
    ATMOSPHERE.kinematic_viscosity = nu;
    ATMOSPHERE.sound_speed = a;
  
end