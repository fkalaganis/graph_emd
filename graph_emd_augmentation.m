function [augmented_trials, augmented_labels]=graph_emd_augmentation(init_trials, init_labels, N, A)
% Input:
%   * my_trials -> A data matrix in the shaoe of [Ntrials x Nsensors x Nsamples].
%
%   * my_labels -> A vector with corresponding labels. The number of
%     should be equal the number of trials (1st dimension of the trials
%     matrix.
%
%   * N ->  Number of new trials in total. The initial class imbalance is
%     is considered so as to maintain the ratio of observations.
%
%   * sample_rep ->  Boolean variable (0 or 1). If True it mirrors the signal
%     at the beggining and the end in order to avoid boundary errors.
%
% Output:
%   * augmented_trials -> A data matrix in the shape of [Ntrials x Nsensors x Nsamples].
%     that contains the artificially generated observations.
%
%   * augmented_labels -> a vector with corresponding, to the artificial
%     observations, labels. The number of labels is equal to the number of
%     trials (1st dimension of the trials matrix.
%
%   * N -> Number of new trials in total. The initial class imbalance is
%     is considered so as to maintain the ratio of observations.
%
%   o The code is based on https://doi.org/10.3389/fnins.2018.00308
%                      and https://doi.org/10.1109/ACCESS.2019.2895133


[ntrials, nsamples]=size(init_trials)
if ntrials~=length(init_labels)
    error('Error: Number of labels should be equal to number of trials')
end

unique_class_ids=unique(init_labels);
augmented_trials=[];
augmented_labels=[];
for i_class=unique_class_ids
    num_of_class_samples = round(sum(init_labels==i_class)/length(init_labels)*N);
    class_idx=find(init_labels== i_class);
    class_trials=init_trials(class_idx,:,:);
    c_imfs={};imf_lens=[];
    for i_trial=1:length(class_idx)
        temp=squeeze(class_trials(i_trial,:));
        imf = graph_emd(temp,A);
        c_imfs{i_trial}=imf';
        imf_len(i_trial)= size(imf',2);
    end
    for i_new_trial=1:num_of_class_samples
        p = randperm(length(class_idx));
        p = p(1:max(max(imf_len)));
        temp_trial=zeros(1,nsamples);
        for i_perm=1:length(p)
            if size(c_imfs{p(i_perm)},2)>=i_perm
                temp_imfs=c_imfs{p(i_perm)};
                temp_trial= temp_trial+squeeze(temp_imfs(:,i_perm))';
            end
        end
        augmented_trials(end+1,:)=temp_trial;
        augmented_labels(end+1)=i_class;
    end
end

end
