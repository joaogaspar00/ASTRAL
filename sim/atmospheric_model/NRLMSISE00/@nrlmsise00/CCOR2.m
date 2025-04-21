%% *CCOR2*
%% *definition*
function [xCCOR2] = CCOR2(ALT, R, H1, ZH, H2)
%% *purpose*
% O and O2 Chemistry/Dissociate Correction for MSIS models
% To calculate a correction factor for the density of a species based on
% the altitude of the atmosphere parcel.
%% *inputs*
%  ALT - [km] altitude
%  R   - [unitless] target ratio
%  H1  - [km] transition scale length
%  ZH  - [km] altitude of 1/2 R
%  H2  - [km] transition scale length
%% *outputs*
%  xCCOR2 - [unitless] factor to apply to a density value
%% *history*
%  when     who   why
%  20190602 mnoah translated from NRLMSISE-90 fortran, added documentation

E1 = (ALT-ZH)/H1;
E2 = (ALT-ZH)/H2;

switch true
    case ( (E1 > 70.0)  || (E2 > 70.0) )
        xCCOR2 = 0.0;
    case ( (E1< -70.0)  && (E2< -70.0) )
        xCCOR2 = R;
    otherwise
        xCCOR2 = R/(1.0+0.5*(exp(E1)+exp(E2)));
end

xCCOR2 = exp(xCCOR2);

end