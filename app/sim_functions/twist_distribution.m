function theta = twist_distribution(BLADE, ROTOR)

slope = (BLADE.tip_theta - BLADE.root_theta) / BLADE.Span;

theta = ones(1, BLADE.No_elements+1);


if BLADE.twistDistribution == 1

    theta = theta * BLADE.root_theta;

elseif BLADE.twistDistribution == 2

    for i=1:length(BLADE.pos_sec)
        theta(i) = slope * BLADE.pos_sec(i) + BLADE.root_theta;      
    end

else
    error("Error - check blade twist")
end

end