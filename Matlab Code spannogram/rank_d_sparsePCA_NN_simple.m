% modification the constant rank solver for sparse PCA of matrices with nonnegative entries
% this solver runs 2^d faster than the general nonnegative one by just
% checking 1 set per intersection point, but by losing at most d/(2*k) from the
% rank-d optimal metric

function [metric supp_opt] = rank_d_sparsePCA_NN_simple(k, V, C)
d = size(V,2);
n = size(V,1);
combs = nchoosek(1:n, d);
metric = 0;
supp_opt = 0;
for i = 1:size(combs,1) % for each d-tuple of curves
    V_inter = V(combs(i,:),:);
    [temp1 temp2 Vr] = svd(V_inter(2:end,:)-kron(ones(d-1,1),V_inter(1,:)));
    % e.g. in rank-2 we check v_i=v_j
    c_inter = Vr(:, end); % this is a sullution to v_i1=...=v_id
    v_phi = V*c_inter; % this is the vector V_d*c on the intersection of i_1...i_d
    [v_phi indx] = sort(v_phi, 'descend');
    for p = 1:2 % here we check two sets, the top and bottom ones
        top_k = indx(1:k);
        if p == 2
            v_phi = flipud(v_phi);
            indx = flipud(indx);
            top_k = indx(1:k);
        end
        supp_new = top_k; 
        [vec_opt, metric_new] = small_eig(C, supp_new); % computes metric of top_k
        if metric_new>metric % if better than previous max, updates max
            metric = metric_new;
            supp_opt = supp_new;
        end
    end
end


