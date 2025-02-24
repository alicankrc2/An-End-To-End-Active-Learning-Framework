function fimg = preProc (Feature,alg)

[no_lines, no_rows, no_bands] = size(Feature);

switch alg.PreProc
    case 'Averaging'
        fimg = average_fusion(Feature,15);
    case 'PCA'
        [Feature]=cchengPCA(Feature,15);
        fimg = Feature';
        fimg = reshape(fimg,no_lines,no_rows,15);
    case 'MNF'
        [HIM_MNF,~]=cchengMNF(Feature);
        fimg = HIM_MNF(:,:,1:15);
    otherwise
        fimg = Feature;
        
end

[no_lines, no_rows, no_bands] = size(fimg);
fimg = reshape(fimg,[no_lines*no_rows no_bands]);

end
