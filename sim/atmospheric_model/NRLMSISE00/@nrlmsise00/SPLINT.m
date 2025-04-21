function [Y] = SPLINT(XA,YA,Y2A,N,X)
%% *purpose*
% To interpolate a value using a cubic spline.
%% *example*
%{
   Amplitude = 1; Period = 4; PhaseShift = pi/4;
   XA = [0:0.01:10];
   YA = Amplitude.*sin(2*pi.*XA./Period - PhaseShift);
   Y2A = -(2*pi/Period)^2*Amplitude.*sin(2*pi.*XA./Period - PhaseShift);
   N = numel(XA);
   X = 9*pi/8;
   [Y] = nrlmsise00.SPLINT(XA,YA,Y2A,N,X);
   figure(); grid on;
   plot(XA,YA,'--','DisplayName','YA'); hold on; 
   plot(XA,Y2A,'--','DisplayName','d^2YA/dx^2'); 
   plot(X,Y,'ok','markerfacecolor','k','DisplayName',['Y(' num2str(X) ') = ' num2str(Y)]);
   legend('location','northeast');
%}
%% *inputs*
% XA, YA - 1D arrays of tabulated function in ascending (monotonically
%          increasing) values of X
% Y2A    - 1D array of second derivative of d^2y/dx^2
% N      - size of XA, YA, Y2A
% X      - abscissa for the interpolation
%% *outputs*
% Y      - value at the abscissa
%% *background*
% Adapted from Numerical Recipes by Press et. al.
%% *history*
%  when     who   why
%  20190523 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

KLO=1;
KHI=N;
while (KHI-KLO > 1)
    K=fix((KHI+KLO)/2);
    if (XA(K)> X)
        KHI=K;
    else
        KLO=K;
    end
end
H=XA(KHI)-XA(KLO);
if (H == 0)
    fprintf(1,'BAD XA INPUT TO SPLINT\n');
end
A=(XA(KHI)-X)/H;
B=(X-XA(KLO))/H;
Y=A*YA(KLO)+B*YA(KHI)+ ...
    ((A^3-A)*Y2A(KLO)+(B^3-B)*Y2A(KHI))*H^2/6.0;

end
