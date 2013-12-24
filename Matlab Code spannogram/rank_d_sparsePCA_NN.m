% the constant rank solver for sparse PCA of matrices with nonnegative entries that was developed in
%
% D. S. Papailiopoulos, A. G. Dimakis, and S. Korokythakis
% "Sparse PCA through Low-rank Approximations"

function [metric supp_opt] = rank_d_sparsePCA_NN(k, V, C)
d = size(V,2);
n = size(V,1);
combs = nchoosek(1:n, d);
p=1;
metric = 0;
supp_opt = 0;
for i = 1:size(combs,1) % for each d-tuple of curves
    V_inter = V(combs(i,:),:);
    [temp1 temp2 Vr] = svd(V_inter(2:end,:)-kron(ones(d-1,1),V_inter(1,:)));
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
        % we now need to check how many curves intersect AND are in the top-k support
        % if there are d'<d, then we need to generate all d choose d' top-k
        % candidate supports and keep the one with the best metric
        curves_in = 0;
        for curve = 1:d % here we count the number of curves in top_k
            is_in = sum(double((top_k-combs(i,curve))==0));
            curves_in = curves_in+is_in;
        end
        if curves_in<d & curves_in>0 % if d'<d curves in top_k generate all possible d choose d' supports
            small_comb = nchoosek(1:d, curves_in);
            for l = 1:size(small_comb,1)
                supp_new =  [top_k(1:k-curves_in); combs(i,small_comb(l,:))'];
                [vec_opt, metric_new] = small_eig(C, supp_new);
                if metric_new>metric
                    metric = metric_new;
                    supp_opt = supp_new;
                end
            end
        else % if all d intersecting, or none of the curves are in the top_k set then we only need to generate 1 candidate
            supp_new = top_k;
            [vec_opt, metric_new] = small_eig(C, supp_new);
            if metric_new>metric
                metric = metric_new;
                supp_opt = supp_new;
            end
        end
        
    end
    
end

end
