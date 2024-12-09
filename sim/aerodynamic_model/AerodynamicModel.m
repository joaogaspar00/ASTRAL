function [CL, CD, i] = AerodynamicModel(alpha, Re, DATA, cmd_debug)

[~, i] = min(abs([DATA.Re] - Re));

    
if cmd_debug == true
    fprintf("Requested AERODAS function... ")
    fprintf("A.o.A = %.2f  | Re = %.2E\n", alpha, Re)
end

aux_alpha = abs(alpha);

%--------------------------------------------------------------------------
% COEFICIENTES DO AERODAS

% PRE-STALL CL
CL1 = AERODAS_prestallRegime_CL(aux_alpha, DATA(i));

% PRE-STALL CD
CD1 = AERODAS_prestallRegime_CD(aux_alpha, DATA(i));


% POST_STALL CL
if aux_alpha >= 0
    CL2 = AERODAS_poststallRegime_CL(aux_alpha, DATA(i));

else
    alpha_ = -aux_alpha + 2 * DATA(i).A0;
    CL2 = - AERODAS_poststallRegime_CL(alpha_, DATA(i));
end

% POST_STALL CD
CD2 = AERODAS_poststallRegime_CD(aux_alpha, DATA(i));

%--------------------------------------------------------------------------

% ESCOLHA DE CD

CD = max(CD1, CD2);


if DATA(i).preStallMode == "NeuralFoil"

    CL_FIT = DATA(i).preStallCurve(abs(aux_alpha));

    if aux_alpha < DATA(i).alpha(DATA(i).stall_index)
        CL= CL_FIT;
    else
        if aux_alpha < DATA(i).alpha
            CL= CL_FIT;
        else
            if aux_alpha <= DATA(i).alpha(end)
                    CL = max(CL_FIT, CL2);
            else
                CL = CL2;
            end
        end
    end

% considera só o AERODAS
else
    % MODEL CURVE DECISION
    if aux_alpha >= DATA(i).A0
        CL = max(CL1, CL2);
    else
        CL = min(CL1, CL2); 
    end
end

if alpha < 0
    CL = -CL;
end


if cmd_debug == true
    fprintf("Results w/ Re = %.2E : ", DATA(i).Re)
    fprintf("CL = %.4f | CD = %.4f \n\n", CL, CD);
end


end