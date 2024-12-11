function azimutalPoints = azimutalDescretization (nPsi, ref)

    step = 2*pi/nPsi;

    azimutalPoints = ref:step:(ref+2*pi-step);

    for i = 1:length(azimutalPoints)
        if azimutalPoints(i) >= 360
            azimutalPoints(i) = azimutalPoints(i)-360;
        end
    end

    azimutalPoints = azimutalPoints';
end