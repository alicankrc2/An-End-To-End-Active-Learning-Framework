function [class,Dist,weights] = E2EAL_Classifier(Train, Test, data, alg)


%% Get Information from Training Set and apply PSACR
train_labels = Train.Set_Train(2,:);
CTrain = hist(train_labels,1:double(max(Train.Set_Train(2,:))));
DataTrain = Train.Data_Train';
DataTrainTrans = DataTrain';
XY = Train.xySet;
DataTest  = Test.Data';
DDT = DataTrain*DataTrain';

train_label = [];
for i = 1:size(CTrain,2)
    train_label = [train_label; i*ones(CTrain(i),1)];
end
H_train = full(ind2vec(train_label',size(CTrain,2)));
[m Nt]= size(DataTest);
DataTest = DataTest';
xyDt = Test.xy;

%%
trSize=size(XY,2);
numClass = length(CTrain);
a = 0;
HX = cell (1,numClass);
indx = cell (1,numClass);
for i = 1: numClass
    indx{i} = (a+1): (CTrain(i)+a);
    HX{i} = DataTrain(indx{i}, :); % sam x dim
    a = CTrain(i) + a;
end

%% Probabilistic Spatial Aware Collaborative Repr. Core Function
Dist = zeros (prod(data.SizeOri(1:2)),numClass);
class = zeros (1,m);
weights = zeros (trSize,m);

for j = 1:m
    
    xy = xyDt(:,j);
    norms = sum((XY - repmat(xy, [1 trSize])).^alg.c);
    norms1 = norms/max(norms);
    D = diag(alg.gamma*norms1);
    
    Y = DataTest(:, j);
    norms = sum((DataTrainTrans - repmat(Y, [1 trSize])).^2);
    G = diag(alg.lambda*norms);
    weights(:,j) = (DDT + G + D)\(DataTrain*Y);
    
    Score = H_train * weights(:,j);
    dist = max(0,Score)/sum(max(0,Score));
    Dist(Test.Set(1,j), :) = dist;
    [~,class(j)] = max(dist);    
    
end
