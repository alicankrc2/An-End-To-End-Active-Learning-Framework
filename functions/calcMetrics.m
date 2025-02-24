function [OA,AA,CA] = calcMetrics (GroudTest,ResultTest)

C = confusionmat(GroudTest,ResultTest);
CA = diag(C)'./sum(C',1);
AA = mean(CA);
OA = sum(diag(C))/sum(C(:));

end