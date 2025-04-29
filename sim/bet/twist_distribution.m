function theta = twist_distribution(BLADE)

theta = zeros(1, length(BLADE.pos_sec));

for i=1:length(BLADE.pos_sec)

    theta(i) = BLADE.twist_rate * (BLADE.pos_sec(2, i)-BLADE.RootBladeDistance) + BLADE.theta;      
end

end

