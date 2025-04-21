classdef RotorAzimutalDistribution
    properties
        blade_distribution_data
        azimutal_position
    end

    methods
        % Construtor
        function obj = RotorAzimutalDistribution(azimutal_position, blade_distribution_data)
        
            obj.blade_distribution_data = blade_distribution_data;
            obj.azimutal_position = azimutal_position;

        end
    end
end
