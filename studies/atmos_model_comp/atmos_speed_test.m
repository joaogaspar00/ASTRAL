clc
clear
close all

groups = [1, 1e1, 1e2, 1e3, 1e4, 1e5];

elapsed_EAM = zeros(1, length(groups));
elapsed_ISA = zeros(1, length(groups));
elapsed_NRL = zeros(1, length(groups));

% Abrir o ficheiro TXT no diretório especificado
fileID = fopen('./studies/atmos_model_comp/speed_results_atmos.txt', 'w');
fprintf(fileID, "%-10s%-20s%-20s%-20s\n", "Samples", "Elapsed_EAM      ", "Elapsed_ISA      ", "Elapsed_NRL      ");

for i = 1:length(groups)

    fprintf(">> Computing %d samples ...", groups(i));

    random_altitudes = rand(groups(i), 1);

    tic
    for j = 1:length(random_altitudes)
        x = EAM_atmospheric_model(random_altitudes(j));
    end
    elapsed_EAM(i) = toc;

    tic
    for j = 1:length(random_altitudes)
        x = ISA_atmospheric_model(random_altitudes(j));
    end
    elapsed_ISA(i) = toc;

    tic
    for j = 1:length(random_altitudes)
        x = NRLMSISE00_atmos_model(random_altitudes(j));
    end
    elapsed_NRL(i) = toc;

    fprintf(" done\n");

    % Ajustar tempos para as unidades apropriadas
    [eam_value, eam_unit] = adjust_time(elapsed_EAM(i));
    [isa_value, isa_unit] = adjust_time(elapsed_ISA(i));
    [nrl_value, nrl_unit] = adjust_time(elapsed_NRL(i));

    % Escrever os resultados no ficheiro com unidades explícitas
    fprintf(fileID, "%-10d%-20s%-20s%-20s\n", ...
            groups(i), ...
            sprintf("%8.1f %s", eam_value, eam_unit), ...
            sprintf("%8.1f %s", isa_value, isa_unit), ...
            sprintf("%8.1f %s", nrl_value, nrl_unit));
end

% Fechar o ficheiro
fclose(fileID);

fprintf("\n>>File saved in'/studies/atmos_model_comp/speed_results_atmos.txt'.\n\n");

% Função auxiliar para ajustar os tempos e unidades
function [value, unit] = adjust_time(time)
    if time < 1
        value = time * 1000; % Converter para milissegundos
        unit = "ms";
    elseif time >= 1 && time < 60
        value = time; % Manter em segundos
        unit = "s";
    else
        value = time / 60; % Converter para minutos
        unit = "min";
    end
end
