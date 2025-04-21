function [this] = TSELEC(this,SV)
%% *purpose*
% Set the switches (flags) that control the component calculations for
% testing and for special purposes.
%% *inputs*
% SV(25,1) array of 
%          0 = OFF
%          1 = ON
%          2 = MAIN EFFECTS OFF BUT CROSS TERMS ON
%% *outputs*
% this.SW  = SV for MAIN TERMS
% this.SWC = SV for CROSS TERMS
% this.ISW = 64999 indicates it has been set
% this.SAV = last values as set by user
%% *background*
% TO TURN ON AND OFF PARTICULAR VARIATIONS CALL TSELEC(SW),
% WHERE SW IS A 25 ELEMENT ARRAY CONTAINING 0. FOR OFF, 1.
% FOR ON, OR 2. FOR MAIN EFFECTS OFF BUT CROSS TERMS ON
% FOR THE FOLLOWING VARIATIONS
%        1 - F10.7 EFFECT ON MEAN  2 - TIME INDEPENDENT
%        3 - SYMMETRICAL ANNUAL    4 - SYMMETRICAL SEMIANNUAL
%        5 - ASYMMETRICAL ANNUAL   6 - ASYMMETRICAL SEMIANNUAL
%        7 - DIURNAL               8 - SEMIDIURNAL
%        9 - DAILY AP             10 - ALL UT/LONG EFFECTS
%       11 - LONGITUDINAL         12 - UT AND MIXED UT/LONG
%       13 - MIXED AP/UT/LONG     14 - TERDIURNAL
%       15 - DEPARTURES FROM DIFFUSIVE EQUILIBRIUM
%       16 - ALL TINF VAR         17 - ALL TLB VAR
%       18 - ALL TN1 VAR          19 - ALL S VAR
%       20 - ALL TN2 VAR          21 - ALL NLB VAR
%       22 - ALL TN3 VAR          23 - TURBO SCALE HEIGHT VAR
%% *history*
%  when     who   why
%  20190523 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

% initialize the arrays
this.SW  = zeros(25,1);
this.SWC = zeros(25,1);
this.SAV = zeros(25,1);
% set the values to user definitions
for I = 1:25
    if (I ~= 10)
        this.SAV(I)=SV(I);
        this.SW(I)=mod(SV(I),2.0);
        if (abs(SV(I)) == 1 || abs(SV(I)) == 2.0)
            this.SWC(I)=1.0;
        else
            this.SWC(I)=0.0;
        end
    else
        this.SAV(I)=SV(I);
        this.SW(I)=SV(I);
        this.SWC(I)=SV(I);
    end
end
this.ISW=64999;

end
