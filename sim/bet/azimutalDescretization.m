function azimutalPoints = azimutalDescretization (nPsi, ref)

    step = 360/nPsi;

    azimutalPoints = ref:step:(ref+360-step);

    for i = 1:length(azimutalPoints)
        if azimutalPoints(i) >= 360
            azimutalPoints(i) = azimutalPoints(i)-360;
        end
    end

    azimutalPoints = azimutalPoints';
end