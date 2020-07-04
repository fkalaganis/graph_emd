function imfs=graph_emd(init_signal,A)
imfs=zeros(size(init_signal));
r_i=init_signal;
L=diag(sum(A))-A;

MAX_ITER=8;
for i_imf=1:MAX_ITER;
    sift_criterion=true;
    [min_list, max_list, num_of_extrema]=graph_extrema(r_i,A);
    if num_of_extrema<=3 | 10*log10((init_signal*L*init_signal')/(r_i*L*r_i'))>40 %termination criteria
        disp('Termination condition reached')
        res=init_signal-sum(imfs,1);
        break %return
    end
    r_i_prev=r_i;
    IN=0;
    while sift_criterion
        emax=graph_interpolation(r_i_prev(max_list),max_list, A);
        emin=graph_interpolation(r_i_prev(min_list),min_list, A);
        mu=(emax+emin)/2;
        r_i_curr=r_i_prev-mu;
        RT=((r_i_curr-r_i_prev)*L*(r_i_curr-r_i_prev)')/(r_i_prev*L*r_i_prev');%norm(r_i_curr-r_i_prev)^2/norm(r_i_prev)^2;%
        IN=IN+1;
        %conditions
        if RT < 0.2
            disp('IMF extracted. Sift Relative Tolerance criterion met')
            imfs(i_imf,:)=r_i_curr;
            i_imf=i_imf+1;
            sift_criterion=false;
            r_i=r_i-r_i_curr;
        elseif IN>= 100
            disp('IMF extracted. Number of iterations reached')
            imfs(i_imf,:)=r_i_curr;
            i_imf=i_imf+1;
            sift_criterion=false;
            r_i=r_i-r_i_curr;
        else
            r_i_prev=r_i_curr;
        end
    end
end
end