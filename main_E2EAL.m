% This code is a demo of "An end-to-end active learning framework for
% limited labelled hyperspectral image classification" method prepared for
% Pavia Univ. dataset.

%% Add Functions to the Path
clear all, clc;
addpath(genpath(pwd));

%% Choose Sampling Methods, Clustering Method (if BvSB-CLSweights is selected), and Dim. Reduction Method
% methods={'RS','MCU','BvSB','EP','BvSB-CLSweights'};
% clster={'kMeans','kMedoids'};
% proc = {'Full','PCA','Averaging','MNF'};
sampMet = 'BvSB-CLSweights';
segMet = 'kMedoids';
dimRedMet = 'MNF';

%% Run the method for 20 times and average over runs
numOfTrials = 2;
numOfClass = 9; % for Pavia University
zTime = zeros(1,numOfTrials);
OA = zeros (numOfTrials,4);
AA = zeros (numOfTrials,4);
CA = zeros (numOfTrials,numOfClass); 

for iter = 1:numOfTrials

    tic;
    alg.AlStra = sampMet;
    alg.PreProc = dimRedMet;
    alg.CLS = segMet;
    disp('------------------------------------');
    disp(['SEED = ',num2str(iter)]);  % Display the iteration number
    alg.RngSeed = iter;               % Random seed parameter

    [data,alg] = E2EAL_paramInit (alg);    
    Dir = E2EAL_SavePath(data,alg);

    %% Generate initialized labeled pixels
    [data, Train] = E2EAL_preprocess(Dir, data, alg);

    Train.Set_All = [];     Train.Data_Train = [];  Train.Set_Train = [];
    Train.Data_Val = [];    Train.Set_Val = [];     Train.xySet = [];

    %% Iterations of the overall algorithm, including data preparation, CNNs' training
    for Ite = 1:alg.NumIter

        %% step 1: data preparation 
        [Train, Test] = E2EAL_prepdata(data, Train);

        %% step 2: train classifier
        [class, Dist,w] = E2EAL_Classifier(Train, Test, data, alg);

        %% step 3: test the rest
        [Train, OA(iter,Ite), AA(iter,Ite), CA(iter,:)] = E2EAL_Test(w,Dir, data, alg, Train, Ite, Test, Dist,class);
    end

    if iter < numOfTrials
        clear alg Train Test data;
    end

    zTime(iter) = toc;
end

meanOA = mean(OA,1)*100; meanAA = mean(AA,1)*100;
stdOA = std(OA,1)*100; stdAA = std(AA,1)*100;
meanCA = mean(CA,1)'*100; stdCA = std (CA,1)'*100;
meanTime = mean(zTime); stdTime = std(zTime);

disp('------------------------------------');
disp(['OA: ',num2str(meanOA(end)),'+-',num2str(stdOA(end))]);
disp(['AA: ',num2str(meanAA(end)),'+-',num2str(stdAA(end))]);
disp('------------------------------------');
