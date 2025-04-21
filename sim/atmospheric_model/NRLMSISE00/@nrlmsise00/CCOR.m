%% *CCOR*
%% *definition*
function [xCCOR] = CCOR(ALT, R, H1, ZH)
%% *purpose*
%  Chemistry/Dissociate Correction for MSIS models.
%  To calculate a correction factor for the density of a species based on
%  the altitude of the atmosphere parcel.
%% *inputs*
%  ALT - [km] altitude
%  R   - [unitless] target ratio
%  H1  - [km] transition scale length
%  ZH  - [km] altitude of 1/2 R
%% *outputs*
%  xCCOR - [unitless] factor to apply to a density value
%% *history*
%  when     who   why
%  20190602 mnoah translated from NRLMSISE-90 fortran, added documentation

E=(ALT-ZH)/H1; % [unitless]
switch true
    case (E > 70.0)
        xCCOR = 0.0;
    case (E < -70.0)
        xCCOR = R;
    otherwise
        xCCOR = R/(1.0+exp(E));
end
xCCOR = exp(xCCOR);

end