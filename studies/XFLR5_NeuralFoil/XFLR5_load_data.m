%% AERODAS - Load XFLR5 DATA
% 
% To run this function, only need to specify the path:
%
% Example:
%
%   folder = "./naca0012_xflr5_data";
%   data = XFLR5_load_data(folder)
% 
% The files must be called CL.csv and CD.csv and directly extracted form
% XFLR5 program - check the file within folfer naca0012_xflr5_data
%%

function data = XFLR5_load_data(folder, fileID, cmd_debug)

    if cmd_debug == true
        fprintf("Loading XFLR5 raw data\n\n");
        fprintf("Folder: %s\n\n", folder);

    end
    if ~isempty(fileID)
        fprintf(fileID, "Loading XFLR5 raw data\n\n");
        fprintf(fileID, "Folder: %s\n\n", folder);
    end


addpath(folder);

CL = readtable('CL.csv');

CD = readtable("CD.csv");

Re_l = floor(size(CL, 2) / 3); % Number of Reynolds numbers (assuming CL has Reynolds numbers as column names)

for i = 0:(Re_l-1)
    % Extract Reynolds number from the column name
    x = CL.Properties.VariableNames{i*3 + 2};
   
    % Regular expression pattern to extract Reynolds number
    pattern = 'Re(\d+)_(\d+)'; 

    % Extract Reynolds number using regular expression
    re_match = regexp(x, pattern, 'tokens');
    
    
    if ~isempty(re_match)
        re_str = [re_match{1}{1} '.' re_match{1}{2}]; % Concatenate the matched strings with a decimal point
        re_number = str2double(re_str); % Convert string to number

        if cmd_debug == true
            fprintf('Reynolds number %.3e loaded\n', re_number*1e6); % Print with three decimal places

        end
        if ~isempty(fileID)
            fprintf(fileID, 'Reynolds number %.3e loaded\n', re_number*1e6); % Print with three decimal places
   
        end

        
        
    else
        fprintf('Reynolds number not found in the string.\n');
        fprintf(fileID, 'Reynolds number not found in the string.\n');
    end
    
    data(i+1).Re = re_number*1e6;
    data(i+1).alfa = CL{:, i*3+1};
    data(i+1).CL = CL{:, i*3+2};
    data(i+1).CD = CD{:, i*3+2};
    
end
end