%% *DNET*
%% *function*
function [NETDENSITY] = DNET(DD,DM,ZHM,XMM,XM)
%% *purpose*
% To calculate a turbopause correction to density for msis models
% Root mean density
% note: The turbopause, also known as the homopause, marks the altitude in 
%       an atmosphere below which turbulent mixing dominates.
%% *inputs*
%  DD  - [cm-3] diffusive density
%  DM  - [cm-3] full mixed density
%  ZHM - transition scale length
%  XMM - [g/mol] full mixed molecular weight
%  XM  - [g/mol] species molecular weight
%% *outputs*
%  NETDENSITY - [cm-3] combined density
%% *history*
%  when     who   why
%  20190602 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

A=ZHM/(XMM-XM);

if ( (DM > 0) && (DD > 0) )
    YLOG = A*log(DM/DD);
    if (YLOG < -10.0)
        NETDENSITY = DD;
    elseif (YLOG > 10.0)
        NETDENSITY = DM;
    else
        if (isempty(YLOG))
            error('[ERROR] YLOG is not initialized in DNET.m');
        end
        NETDENSITY = DD*(1.0+exp(YLOG))^(1.0/A);
    end
else
    fprintf(1,'DNET LOG ERROR %g %g %g\n',DM,DD,XM);
    if ( (DD == 0) && (DM == 0) )
        DD = 1.0;
    end
    if (DM == 0)
        NETDENSITY = DD;
    elseif (DD == 0)
        NETDENSITY = DM;
    end
end

end

      