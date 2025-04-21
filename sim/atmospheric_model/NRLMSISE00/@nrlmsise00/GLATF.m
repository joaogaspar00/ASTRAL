%% *GLATF*
%% *function*
function [REFF,GV] = GLATF(LAT)
%% *purpose*
% to calculate the acceleration due to gravity and the effective radius of
% the ellipsoidal earth as a function of latitude
%% *example*
%{
    LAT = 42; % [degN]
    [REFF,GV] = nrlmsise00.GLATF(LAT);
    fprintf(1,'Re(%.3f) = %f [km]\n',LAT,REFF);
    fprintf(1,'g(%.3f) = %f [cm/s^2]\n',LAT,GV);
%}
%% *inputs*
%  LAT  - [degN] latitude
%% *outputs*
%  GV   - [cm/s^2 or gal] acceleration due to gravity at this latitude
%  REFF - [km] effective radius of the earth at this latitude
%% *background*
% The most siginificant variable for determining acceleration due to
% gravity at the surface of Earth is latitude.  The reasons are:
% 1) The Earth has an equatorial bulge; its ellipsoidal shape resulted from
%    the centrifugal forces as the Earth was spinning while it cooled.
% 2) The centrifugal forces due to Earth's spin yields an outward
%    acceleration (m^v^2/R) that substracts from the Earth's gravity.
% The local value of g, in m/s^2, at sea level can be calculated from:
%%
% $$g = 9.80613 ( 1 - 0.0026325 cos( 2 \theta) )$$
%
% where
% $\theta$ is the latitude
%% *history*
%  when     who   why
%  20190523 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*
if (~exist('LAT','var'))
    LAT = 45;
end
C2 = cosd(2.*LAT);
GV = 980.616*(1.-.0026373*C2); % [cm/s^2 or gals]
REFF = 2.*GV/(3.085462E-6 + 2.27E-9*C2)*1.E-5;  % [km]
end