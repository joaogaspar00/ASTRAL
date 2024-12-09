clc;
clear;
close all;

Re = logspace(3, 8, 25);  % Número de Reynolds

dAlpha = 0.25;  % Incremento de ângulo de ataque

AR = Inf;
tc = 0.12;

for i = 1:length(Re)
    k = 1;  % Inicializando o contador
    alpha = 0 - dAlpha;  % Inicializando o ângulo de ataque fora do loop

    % Inicializando os vetores CL, CD e conf
    CL = [];  % Inicializa o vetor CL
    CD = [];  % Inicializa o vetor CD
    conf = [];  % Inicializa o vetor de confiança
    v_alpha = [];  % Inicializa o vetor de ângulos de ataque

    fprintf("--> Re: %.2e\n", Re(i))

    stall_angle = -1;
    stallFound = false;
    stall_criterion = 0 ;

    while true
        % Incrementa o ângulo de ataque
        alpha = alpha + dAlpha;  % Atualiza alpha        

        % Chama a função NeuralFoil para obter CL, CD e a confiança
        [cl, cd, cf] = NeuralFoil("naca0012", Re(i), 0, alpha);

        if cf < 0.90
            break;
        end        

        v_alpha(k) = alpha;
        CL(k) = cl;
        CD(k) = cd;
        conf(k) = cf;

        if k>1
            if CL(k) >= CL(k-1)
                if ~stallFound
                    stall_angle = alpha;
                    stall_cl = cl;
                    stall_index = k;
                end
            else
                stall_criterion = stall_criterion + 1;
                if stall_criterion == 2
                    if alpha > 2.5
                        stallFound = true;
                    end
                end
            end
        end
        k = k + 1;  % Incrementa o contador para a próxima iteração
    end

    if length(v_alpha) < 20
        continue;
    end

    % Armazena os resultados no struct DATA
    X = AERODAS_model_coefficients(Re(i), v_alpha, CL, CD, conf, stall_index, stall_angle, stall_cl, tc, AR);
    if ~isempty(X)
        DATA(i) = X;
    end

end

airfoil.name = "naca0012";

DATA = AERODAS_AR_correction(DATA, AR);
airfoil.data = DATA(~cellfun('isempty', {DATA.Re}));

save('./airfoils/naca0012.mat', 'airfoil');