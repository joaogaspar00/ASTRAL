function [xSCALH] = SCALH(this,ALT,XM,TEMPERATURE)
%% *purpose*
% To calculate scale height. 
% (a scale height is a distance over which a quantity decreases 
%  by a factor of e)
%% *inputs*
% ALT         - [km] geodetic altitude of air parcel above sea level
% XM          - [kg/mol] mean molecular molar mass of air particle 
%                        note: one atmospheric particle = 0.029 kg/mol 
%                              near surface of Earth
% TEMPERATURE - [K] temperature of air parcel
%% *outputs*
% xSCALH      - [km] scale height
%% *other variables*
% G    - [cm/s^2] acceleration due to gravity
% RGAS - [J/K mol] universal gas constant
%% *formula*
%% 
% $$H=\frac{RT}{Mg}$$
%
%% *history*
%  when     who   why
%  20190602 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

% if (~exist('this','var'))
%     this.GSURF = 981;
%     this.RE = 6371;
%     this.RGAS = 100*8.31446261815324;
%     ALT = 550;
%     XM = 16; 
%     TEMPERATURE = 4000;
% end

G = this.GSURF/(1.0 + ALT/this.RE)^2;   % [cm/s^2]
xSCALH = 100.0*this.RGAS*TEMPERATURE/(G*XM);  % [km] units cancel to km

end