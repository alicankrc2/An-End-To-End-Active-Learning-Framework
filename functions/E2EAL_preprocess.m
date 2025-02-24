function [data, Train] = E2EAL_preprocess(Dir, data, alg)

Img_Size = data.SizeOri(1:2);

% Load feature and ground truth labels: Feature.mat, GT.mat
load(fullfile(Dir.Data, data.NameMat{1}));
load(fullfile(Dir.Data, data.NameMat{2}));
GT = double(GT);
data.GT = GT;

%% Apply Dim. Reduction, Normalization and Domain Transform Filtering
[no_lines, no_rows, ~] = size(Feature);
fimg = preProc (Feature,alg);
[~, no_bands] = size(fimg);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[no_lines no_rows no_bands]);
Feature = spatial_feature(fimg,alg.pr,0.3);
data.F_norm = Feature;

%% randomly select the training set
GT_1d = data.GT(:)';
GT_indexes = find(GT_1d);
Train.Pool = [GT_indexes; GT_1d(GT_indexes)];

%% randomly sampling with seed
rng(alg.RngSeed), tmp = randperm(length(GT_indexes));
tmp_indexes = GT_indexes(tmp);
tmp_GT = GT_1d(tmp_indexes);
if strcmp(alg.SampleSty, 'Classwise') && strcmp(alg.CountSty, 'Ratio')
    Train.Set = [];
    for l=1:max(tmp_GT)
        Train_GlbIndexes = tmp_indexes(find(tmp_GT==l));
        %tmp = max(floor(length(Train_GlbIndexes)*alg.RatioTrn1st), 2);
        tmp = ceil(length(Train_GlbIndexes)*alg.RatioTrn1st);
        Train_Set = [Train_GlbIndexes(1:tmp);GT_1d(Train_GlbIndexes(1:tmp))];
        Train.Set = [Train.Set, Train_Set];
    end
elseif strcmp(alg.SampleSty, 'Rd') && strcmp(alg.CountSty, 'Num')
    Train_GlbIndexes = tmp_indexes(1:alg.NumTrn1st);
    Train.Set = [Train_GlbIndexes; GT_1d(Train_GlbIndexes)];
end