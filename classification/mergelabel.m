% % merge similar labels and renumber them
% % refining segmented image labels by merging adjacent regions with similar values
% % L: The original label matrix.
% % N: The number of original labels.
% % im: The original image data, used to calculate the mean value of each labeled region.
% % Search the label of each segmented region, with a maximum of 10 iterations.
% % Traverse all labels, calculate the mean and standard deviation of the region and its neighboring labels.
% % If the mean difference is within 0.05, they are considered the same category and merged.
% % Finally, renumber all the labels.
function [Lmerge,Nmerge]=mergelabel(L,N,im)
    iteration=10;
    Lmerge=L;
    Nmerge=N;
    tmp=label2idx(Lmerge);
    
    % for j=1:Nmerge
    %     pxID=tmp{j};
    %     pxDN=im(pxID);
    %     if mean(pxDN)==0
    %         Lmerge(tmp{j})=0;
    %     end
    % end
    % Lmerge(Lmerge == 0) = max(Lmerge) + 1;

    Nmerge=length(unique(Lmerge));
    if Nmerge > 100
        for i=1:iteration
            idx = label2idx(Lmerge);
            id=cellfun('length',idx);
            idx(id==0)=[];
            for labelVal = 2:Nmerge
                pxID = idx{labelVal};
                pxID_1 = idx{labelVal-1};
                pxDN=im(pxID);
                pxDN_1=im(pxID_1);
                mean1=mean(pxDN);
                mean2=mean(pxDN_1);
                if abs(mean1-mean2)<0.02
                    Lmerge(idx{labelVal-1})=labelVal;
                    idx{labelVal}=[idx{labelVal};idx{labelVal-1}];
                end
            end
            Nmerge=length(unique(Lmerge));
            if N==Nmerge || Nmerge<100
                break;
            end
            N=Nmerge;
        end
        label=unique(Lmerge);
        idx2 = label2idx(Lmerge);
        id=cellfun('length',idx2);
        idx2(id==0)=[];
        for j=1:length(label)
            Lmerge(idx2{j})=j;
        end
    end
end