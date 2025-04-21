function [YI] = SPLINI(XA,YA,Y2A,N,X)
%% *purpose*
% To integrate a cubic spline function from XA(1) to X
%% *example*
%{
   Amplitude = 1e-3; Period = 4; PhaseShift = 0;
   XA = [0:0.001:8];
   YA = Amplitude.*sin(2*pi.*XA./Period - PhaseShift);
   Y2A = -(2*pi/Period)^2*Amplitude.*sin(2*pi.*XA./Period - PhaseShift);
   N = numel(XA);
   X = 8;
   [Y] = nrlmsise00.SPLINI(XA,YA,Y2A,N,X);
   figure(); grid on;
   plot(XA,YA,'--','DisplayName','YA'); hold on;
   plot(XA,Y2A,'--','DisplayName','d^2YA/dx^2');
   title(['Area under curve YA = ' num2str(Y)]);
   legend('location','northeast');
%}
%% *inputs*
%  XA,YA - Nx1 ARRAYS OF TABULATED function IN ASCENDING ORDER BY X
%  Y2A   - Nx1 ARRAY OF SECOND DERIVATIVES
%  N     - SIZE OF ARRAYS XA,YA,Y2A
%  X     - ABSCISSA ENDPOINT FOR INTEGRATION
%% *outputs*
%  YI    - OUTPUT VALUE
%% *history*
%  when     who   why
%  201906602 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

YI=0;
KLO=1;
KHI=2;

while (X> XA(KLO) && KHI<= N)  
    XX=X;
    if (KHI< N)
        XX=min([X,XA(KHI)]);
    end
    H=XA(KHI)-XA(KLO);
    A=(XA(KHI)-XX)/H;
    B=(XX-XA(KLO))/H;
    A2=A*A;
    B2=B*B;
    YI=YI+((1.0-A2)*YA(KLO)/2.0+B2*YA(KHI)/2.0+ ...
        ((-(1.+A2*A2)/4.0+A2/2.0)*Y2A(KLO)+ ...
        (B2*B2/4.0-B2/2.0)*Y2A(KHI))*H*H/6.0)*H;
    KLO=KLO+1;
    KHI=KHI+1;
end

end

