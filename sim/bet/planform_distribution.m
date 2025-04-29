function BLADE = planform_distribution(BLADE)

BLADE.chord = zeros(1, length(BLADE.pos_sec));
BLADE.theta = zeros(1, length(BLADE.pos_sec));

for i = 1:length(BLADE.pos_sec)
    
    y_rel = BLADE.pos_sec(2, i) - BLADE.RootBladeDistance; % distância radial desde a raiz
    
    % taper aplicado corretamente com lambda
    BLADE.chord(i) = BLADE.root_chord * (1 - (1 - BLADE.lambda_chord) * y_rel / BLADE.Span);

    % twist
    BLADE.theta(i) = BLADE.twist_rate * y_rel + BLADE.root_theta;

end

end
