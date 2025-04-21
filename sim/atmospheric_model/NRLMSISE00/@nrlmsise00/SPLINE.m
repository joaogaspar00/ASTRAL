function Y2 = SPLINE(X,Y,N,YP1,YPN)
%% *purpose*
% To calculate 2nd derivatives of cubic spline interp functions
% In nrlmsis, these are used as inputs to SPLINI and SPINT
%% *inputs*
%  X,Y     - Nx1 arrays of tabulated function in ascending order by X
%  N       - size of arrays X,Y
%  YP1,YPN - specified derivates at X(1) and X(N)
%            value >= 1E30 signal 2nd derivative is zero
%% *outputs*
%  Y2 - OUTPUT ARRAY OF SECOND DERIVATIVES
%% *references*
% Adapted from Numerical Recipes by PRESS et al
%% *history*
%  when     who   why
%  20190602 mnoah translated from NRLMSISE-90 fortran, added documentation
%% *start*

U = zeros(size(X));
Y2 = zeros(size(X));

if (YP1 > 0.99E30)
    Y2(1)=0;
    U(1)=0;
else
    Y2(1)=-0.5;
    U(1)=(3.0/(X(2)-X(1)))*((Y(2)-Y(1))/(X(2)-X(1))-YP1);
end


for I=2:N-1
    SIG=(X(I)-X(I-1))/(X(I+1)-X(I-1));
    P=SIG*Y2(I-1)+2.0;
    Y2(I)=(SIG-1.0)/P;
    U(I)=(6.0*((Y(I+1)-Y(I))/(X(I+1)-X(I))-(Y(I)-Y(I-1))/(X(I)-X(I-1)))/(X(I+1)-X(I-1))-SIG*U(I-1))/P;
end

if (YPN > 0.99E30)
    QN=0;
    UN=0;
else
    QN=0.5;
    UN=(3.0/(X(N)-X(N-1)))*(YPN-(Y(N)-Y(N-1))/(X(N)-X(N-1)));
end

Y2(N)=(UN-QN*U(N-1))/(QN*Y2(N-1)+1.0);
for K=N-1:-1:1
    Y2(K)=Y2(K)*Y2(K+1)+U(K);
end
   
end