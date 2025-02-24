function [data,alg]=E2E_paramInit (alg)

%% DTF Parameters
alg.c      = 4;
alg.lambda = 1e-3;
alg.gamma  = 1e-2;
alg.pr = 4;

%% Parameters for Data
data.NameFolder = {};
data.NameMat = {'GT.mat', 'Feature.mat'};
data.NameFolder = 'PaviaU';
data.SizeOri = [610, 340, 103];
data.NumClass =  9;
data.IndBand = [12, 67, 98];

%% Parameters for Algorithm
alg.SampleSty = 'Classwise'; 
alg.CountSty = 'Ratio'; 
alg.RatioTrn1st = 0.001;
alg.NumAlAugPerIte = [12, 12, 12, 12]; % The training samples added in each iteration 
alg.NumIter = length(alg.NumAlAugPerIte)+1;