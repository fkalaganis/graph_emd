function [augmented_trials, augmented_labels]=emd_augmentation(init_trials, init_labels, N, sample_rep)
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
%     The code is based on https://doi.org/10.3389/fnins.2018.00308
%                      and https://doi.org/10.1109/ACCESS.2019.2895133

if sample_rep
    mirror_trials=init_trials(:,:,end:-1:1);
    my_trials=cat(3, init_trials, mirror_trials);
    init_trials=cat(3, mirror_trials, my_trials);
end
[ntrials, nsensors, nsamples]=size(init_trials)
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
        temp=squeeze(class_trials(i_trial,:,:));
        for i_sensor=1:nsensors
            [imf,residual] = emd(squeeze(temp(i_sensor,:)));
            c_imfs{i_trial,i_sensor}=imf;
            imf_len(i_trial,i_sensor)= size(imf,2);
        end
        
    end
    for i_new_trial=1:num_of_class_samples
        p = randperm(length(class_idx));
        p = p(1:max(max(imf_len)));
        temp_trial=zeros(nsensors,nsamples);
        for i_perm=1:length(p)
            for i_sensor=1:nsensors
                if size(c_imfs{p(i_perm),i_sensor},2)>=i_perm
                    temp_imfs=c_imfs{p(i_perm),i_sensor};
                    temp_trial(i_sensor,:)= temp_trial(i_sensor,:)+squeeze(temp_imfs(:,i_perm))';
                end
            end
        end
        augmented_trials(end+1,:,:)=temp_trial;
        augmented_labels(end+1)=i_class;
    end
end
if sample_rep
    augmented_trials=augmented_trials(:,:,nsamples/3+1:2*nsamples/3);
end
end
