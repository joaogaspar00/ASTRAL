classdef RotorTimeDistribution
    properties
        rotor_azimutal_distribution_data
        time

    end

    methods
        % Construtor
        function obj = RotorDistribution(time, rotor_azimutal_distribution_data)
        
            obj.rotor_azimutal_distribution_data = rotor_azimutal_distribution_data;
            obj.time = time;

        end
    end
end
