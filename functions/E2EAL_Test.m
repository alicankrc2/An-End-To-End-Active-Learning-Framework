function [Train, OA, AA, CA] = E2EAL_Test(w,Dir, data, alg, Train, Ite, Test, Data_Cost, Result)


GroudTest = double(Test.Set(2,:));
ResultTest = Result;
[OA,AA,CA] = calcMetrics (GroudTest,ResultTest);

disp ('-----------------------------------');
disp(['Ite = ', num2str(Ite), ', OA = ', num2str(OA*100), '%']);
save(strcat(Dir.Results, '\Result-OA', '-Ite', num2str(Ite), '.mat'), 'Result');
fid = fopen(strcat(Dir.Results, '\Accuracy1.txt'), 'a+');
fprintf(fid, 'Ite:%d, Epoch:%d, \nOA: %-8.4f%%\r\n', num2str(Ite), OA*100);

for l=1:max(Result)
    fprintf(fid, 'Class #%d: %-8.4f%%\r\n', l, CA(l)*100);
end
fprintf(fid, 'AA #%d: %-8.4f%%\r\n', l, mean(AA)*100);
disp(['Ite = ', num2str(Ite), ', AA = ', num2str(mean(AA)*100), '%']);
fclose(fid);

% Except for the final epoch, add new samples to train set
if (Ite < alg.NumIter)
    if strcmp(alg.AlStra, 'BvSB') % by active learning
        
        ALIncr = Data_Cost(Train.Pool(1,:), :);
        ALIncrsort = sort(ALIncr, 2, 'descend');
        ALIncrsort_MinBT = ALIncrsort(:, 1) - ALIncrsort(:, 2);
        [~, indexsortminppBT] = sort(ALIncrsort_MinBT );
        xp = indexsortminppBT(1:alg.NumAlAugPerIte(Ite));
        
        
    elseif strcmp(alg.AlStra, 'BvSB-CLSweights')% by mixed
        
        ALIncr = Data_Cost(Train.Pool(1,:), :);
        ALIncrsort = sort(ALIncr, 2, 'descend');
        ALIncrsort_MinBT = ALIncrsort(:, 1) - ALIncrsort(:, 2);
        [~, indexsortminppBT] = sort(ALIncrsort_MinBT );
        w = w';
        selectTenTimes = w(indexsortminppBT(1:900),:);
        clusterNum = round(alg.NumAlAugPerIte(Ite)/1);

        switch alg.CLS
            case 'kMeans'
                [C, idx]= kmeans(selectTenTimes,clusterNum,'Distance','cosine','MaxIter',10000);
                % C 
            case 'kMedoids'
                [C, idx]= kmedoids(selectTenTimes,clusterNum,'Distance','cosine');
  
        end
        xp =  [];
        xpInd = [];
        for iii=1:clusterNum
            ss = selectTenTimes - repmat(idx(iii,:),size(selectTenTimes,1),1);
            vect = sum(abs(ss),2);
            [vect2,ind] = sort(vect,'ascend');
            ind(~intersect(ind,xpInd))=[];
            
            xp =  [xp, indexsortminppBT(ind(1))];
            xpInd = [xpInd,ind(1)];
            
        end
        
    elseif strcmp(alg.AlStra, 'RS')% by random sampling
        rng(alg.RngSeed);
        tmp = randperm(size(Train.Pool, 2));
        xp = tmp(1:alg.NumAlAugPerIte(Ite)); % ###
        
    elseif strcmp(alg.AlStra, 'EP')
        numCls = max(Test.Set(2,:));
        ALIncr = Data_Cost(Train.Pool(1,:), :) + eps;
        ALEntropy = zeros(1,size(ALIncr,1));
        for m = 1:size(ALIncr,1)
            ALEntropy(m) = -sum(ALIncr(m,:).*log2(ALIncr(m,:)));
        end
        ALEntropy = ALEntropy/log2(numCls);
        [~, indexsortALEntropy] = sort(ALEntropy, 'descend');
        xp = indexsortALEntropy(1:alg.NumAlAugPerIte(Ite));
        
    elseif strcmp(alg.AlStra, 'MCU') % Minimum Conf. / Least Confidence
        numCls = max(Test.Set(2,:));
        ALIncr = Data_Cost(Train.Pool(1,:), :) + eps;
        ALIncr = numCls*(1-max(ALIncr,[],2))/(numCls-1);
        [~, indexsortALEntropy] = sort(ALIncr, 'descend');
        xp = indexsortALEntropy(1:alg.NumAlAugPerIte(Ite));
    end
    
    Train.Set = Train.Pool(:,xp);
    
end

end
