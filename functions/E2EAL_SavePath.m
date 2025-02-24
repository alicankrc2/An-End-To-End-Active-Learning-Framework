function Dir = E2EAL_SavePath(data,alg)

Dir.Cur = pwd;
addpath(genpath(Dir.Cur));

%% make folders
cd ..
cd ..
Dir.Root = pwd;
Dir.Exp = strcat(pwd, '\data\HSI\', data.NameFolder, '\RngSeed-', num2str(alg.RngSeed));

Dir.Exp = fullfile(Dir.Exp, 'End2EndActiveLearning');

Dir.Results = fullfile(Dir.Exp, 'Results');

if ~exist(Dir.Exp) || ~exist(Dir.Results)
    mkdir(Dir.Exp);
    mkdir(Dir.Results);
end

cd(Dir.Cur)
Dir.Data = fullfile(pwd, 'Data', data.NameFolder);


end