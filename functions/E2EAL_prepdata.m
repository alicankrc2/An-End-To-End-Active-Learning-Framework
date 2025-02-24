function [Train, Test] = E2EAL_prepdata(data, Train)

%% Update train set and train pool for all
Train.SetAll = [Train.Set_All, Train.Set];
for i = 1:size(Train.Set, 2)
    Train.Pool(:, find(Train.Pool(1, :) == Train.Set(1, i))) = [];
end

%% Construct Test Dataset
Test.Set = Train.Pool;
Test.Num = size(Train.Pool, 2);
Test.Data = zeros(size(data.F_norm,3), Test.Num);
Test.xy = zeros(2, Test.Num);
for i=1:Test.Num
    [x, y] = Index1Dto2D(Test.Set(1,i), data.SizeOri(1), data.SizeOri(2));
    % patch center index: x+HalfWin, y+HalfWin
    Test.Data(:,i) = [squeeze(data.F_norm(x, y, :))];
    Test.xy(:,i) = [x;y];
end

%% construct Train Dataset: load padded feature into #Train_num voxels
Train_num = size(Train.Set, 2);
Train_Data = zeros(size(data.F_norm,3), Train_num);
Train.xy = zeros(2, Train_num);
for i=1:Train_num
    [x, y] = Index1Dto2D(Train.Set(1,i), data.SizeOri(1), data.SizeOri(2));
    Train_Data(:,i) = [squeeze(data.F_norm(x, y, :))];
    Train.xy(:,i) = [x; y];
end

Train.Data_Train = cat(2, Train.Data_Train, Train_Data);
Train.Set_Train = cat(2, Train.Set_Train, Train.Set);
Train.xySet = cat(2, Train.xySet, Train.xy);

[~,indices] = sort(Train.Set_Train(2,:));
Train.Set_Train = Train.Set_Train(:,indices);
Train.Data_Train = Train.Data_Train(:,indices);
Train.xySet = Train.xySet(:,indices);

end