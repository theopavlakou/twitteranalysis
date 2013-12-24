% the constant rank solver for sparse PCA that was developed in
%
% M. Asteris, D. S. Papailiopoulos, and G. N. Karystinos, 
% "The Sparse Principal Component of a Constant-rank Matrix" 

function [metric supp_opt] = rank_d_sparsePCA(k, V, C)
d = size(V,2); % rank-d of the constant rank solver
n = size(V,1);
combs = nchoosek(1:n, d); % stores the d-tuple of curve indices that will be intersecting
V = V+10^-10*randn(n,d); % adds a small perturbation to avoid singularities
metric = 0;
supp_opt = 0;
for i = 1:size(combs,1) % for each d-tuple of curves intersecting
    V_inter = V(combs(i,:),:);
    signs = [-ones(2^(d-1),1) 2*(dec2bin(0:2^(d-1)-1)-48)-1]; % stores all 2^{d-1} sign patterns for the intersection points
    % e.g. in rank-3 we check v_i=v_j=v_k, v_i=v_j=-v_k, v_i=-v_j=v_k, v_i=-v_j=-v_k 
    for j=1:2^(d-1) % for each sign pattern
        V_inter_signed = diag(signs(j,:))*V_inter;
        V_inter = V(combs(i,:),:);
        [temp1 temp2 Vr] = svd(V_inter_signed(2:end,:)-kron(ones(d-1,1),V_inter_signed(1,:)));
        c_inter = Vr(:, end); % one solution to the equation [Vc]_{i_1}=... = [Vc]_{i_d} over c       
        v_phi = V*c_inter; % compute the V_d*c_ij vector that lies in the span of V_d 
        % v_phi are the n curve values on the intersection point of curves i_1...i_d
        [temp indx] = sort(abs(v_phi), 'descend'); % sort V_d*c_ij
        top_k = indx(1:k);
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
