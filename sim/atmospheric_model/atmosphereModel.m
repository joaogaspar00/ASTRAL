function ATMOSPHERE = atmosphereModel (height, SIM)
    
    % global sim_data 

    gamma = 1.4;
    R = 287.053;

    if strcmp(SIM.atmosphereModel, 'Null')
        if height <= 11000
            T = 15.04 - 0.00649 * height;
            p = 101.29 * ((T + 273.1) / 288.08)^5.256;
        elseif height > 11000 && height <= 25000
            T = -56.46;
            p = 22.65 * exp(1.73 - 0.000157 * height);
        else
            T = -131.21 + 0.00299 * height;
            p = 2.488 * ((T + 273.1) / 216.6)^(-11.388);
        end
        
        rho = p / (0.2869 *  (T +273.5));

        a = sqrt(gamma * R * T);

        mu = 1.716e-5*((T/273)^(3/2))*(384/(T+111));

        nu = mu / rho;

    elseif strcmp(SIM.atmosphereModel, 'atmosisa')
        [T,a,p,rho,nu, mu] = atmosisa (height);
    else
        error("Simulation Error: Selected atmosphere model is not valid");
    end
   

    
    ATMOSPHERE.temperature = T;
    ATMOSPHERE.pressure = p;
    ATMOSPHERE.density = rho;
    ATMOSPHERE.dynamicVisvosity = mu;
    ATMOSPHERE.kinematicViscosity = nu;
    ATMOSPHERE.soundSpeed = a;

    % sim_data.temperature = [sim_data.temperature; ATMOSPHERE.temperature];
    % sim_data.pressure = [sim_data.pressure; ATMOSPHERE.pressure];
    % sim_data.density = [sim_data.density; ATMOSPHERE.density];
    % sim_data.dynamicVisvosity = [sim_data.dynamicVisvosity; ATMOSPHERE.dynamicVisvosity];
    % sim_data.kinecticViscosity = [sim_data.kinecticViscosity; ATMOSPHERE.kinematicViscosity];
    % sim_data.soundSpeed = [sim_data.soundSpeed; ATMOSPHERE.soundSpeed];
end