function [CL, CD, i] = AerodynamicModel(alpha, Re, DATA, cmd_debug)

[~, i] = min(abs([DATA.Re] - Re));

if cmd_debug == true
    fprintf("Requested AERODAS function... ")
    fprintf("A.o.A = %.2f  | Re = %.2E\n", alpha, Re)
end

%--------------------------------------------------------------------------
% COEFICIENTES DO AERODAS

CL1 = AERODAS_prestallRegime_CL(alpha, DATA(i));

CD1 = AERODAS_prestallRegime_CD(alpha, DATA(i));

if alpha >=0
    CL2 = AERODAS_poststallRegime_CL(alpha, DATA(i));
else
    CL2 = -AERODAS_poststallRegime_CL(-alpha + 2*DATA(i).A0, DATA(i));
end

if alpha >  2*DATA(i).A0 - DATA(i).ACD1
    CD2 = AERODAS_poststallRegime_CD(alpha, DATA(i));
else
    CD2 = AERODAS_poststallRegime_CD(-alpha + 2*DATA(i).A0, DATA(i));
end

%--------------------------------------------------------------------------

CD = max(CD1, CD2);

% ESCOLHA DE CD

if DATA(i).preStallMode == "NeuralFoil"

    CL_FIT = DATA(i).preStallCurve_CL(alpha);

    if alpha < DATA(i).alpha(DATA(i).stall_index)
        CL = CL_FIT;
    else
        if alpha <= DATA(i).alpha(end)
            CL = max(CL_FIT, CL2);
        else
            CL = CL2;
        end
    end
else
    % MODEL CURVE DECISION
    if alpha >= DATA(i).A0
        CL = max(CL1, CL2);
    else
        CL = min(CL1, CL2); 
    end
end


f_CD = DATA(i).preStallCurve_CD;

if alpha < DATA(i).ACD1
    CD = f_CD(alpha);
end

if cmd_debug == true
    fprintf("Results w/ Re = %.2E : ", DATA(i).Re)
    fprintf("CL = %.4f | CD = %.4f \n\n", CL, CD);
end


end