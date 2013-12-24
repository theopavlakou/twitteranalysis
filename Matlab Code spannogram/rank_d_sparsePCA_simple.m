% modificaiton of the constant rank solver for sparse PCA that was developed in
%
% M. Asteris, D. S. Papailiopoulos, and G. N. Karystinos,
% "The Sparse Principal Component of a Constant-rank Matrix"
% this only checks one support per intersection, which incurs an
% approximation error of at most (d/2*k)

function [metric supp_opt] = rank_d_SPCA(k, V, C)
d = size(V,2); % rank-d of the constant rank solver
n = size(V,1);
combs = nchoosek(1:n, d); % stores the d-tuple of curve indices that will be intersecting
V = V+10^-10*randn(n,d); % adds a small perturbation to avoid singularities
metric = 0;
supp_opt = 0;
for i = 1:size(combs,1) % for each d-tuple of curves intersecting
    V_inter = V(combs(i,:),:);
    signs = [-ones(2^(d-1),1) 2*(dec2bin(0:2^(d-1)-1)-48)-1]; % stores all 2^{d-1} sign patterns for the intersection points
    % e.g. in rank-2 we check v_i=v_j=v_k, v_i=v_j=-v_k, v_i=-v_j=v_k, v_i=-v_j=-v_k
    for j=1:2^(d-1) % for each sign pattern
        V_inter_signed = diag(signs(j,:))*V_inter;
        V_inter = V(combs(i,:),:);
        [temp1 temp2 Vr] = svd(V_inter_signed(2:end,:)-kron(ones(d-1,1),V_inter_signed(1,:)));
        c_inter = Vr(:, end); % one solution to the equation [Vc]_{i_1}=... = [Vc]_{i_d} over c
        v_phi = V*c_inter; % compute the V_d*c vector that lies in the span of V_d
        % v_phi are the n curve values on the intersection point of curves i_1...i_d
        [temp indx] = sort(abs(v_phi), 'descend'); % sort V_d*c
        top_k = indx(1:k);
        supp_new = top_k;
        [vec_opt, metric_new] = small_eig(C, supp_new); % check metric of top_k
        if metric_new>metric % update opt if needed
            metric = metric_new;
            supp_opt = supp_new;
        end 
    end
end
