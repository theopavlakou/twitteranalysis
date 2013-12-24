%[PCs, supports, metrics] = spannogram_sparsePCA(l, k, d, A, dfl, pos, elim, simple)    
%--------------------------------------------------------------------------
%Sparse PCA using the spannogram algorithm.
%Version 1.0
%Date: 21/06/2013
%
%Input:
%   l: requested number of PCs to be extracted, l>0
%   k: levels of sparsity for each PC, e.g. k = [5, 4, 3, 2, 5]
%   d: accuracy parameter (the rank of the approximation)
%      (d: 1 is PCA+thresholding, 
%       d: 2,3, usually perform near optimally, with d=2 being much faster)
%   A: PSD input matrix for which sparse PCs will be extracted
%   dfl: deflation method used
%        (0: zero-forcing, 
%         1: projection deflation, 
%         2: Schur complement deflation)
%   pos: flag indicating if A has only nonnegative entries
%   elim: flag indicating if/what elimination procedure will be run
%         (0: no eliminations is faster if poor elimination is expected
%          1: based on the spannogram theory (provably safe)
%          2: row sub-sampling elimination (not provably safe)
%   simple: if set to 1, the constant rank solver checks 1 candidate
%   support for each intersection point. This can reduce computation by an
%   extra factor of at most 2^d, but incurs a potential loss in the
%   metric upper bounded by d/k. This will be vanishing if k grows with n.
%
%Output: 
%   PCs: the list of extracted sparse PCs
%   supports: the supports of the nonnzero elements of the sparse PCs
%   metrics: explained variance obtained by each PC
%
%Notes:  This version of the code uses eigs, change to eig if data set is
%dense
%--------------------------------------------------------------------------
function [PCs, supports, metrics] = spannogram_sparsePCA(l, k, d, A, dfl, pos, elim, simple)
fprintf('\n---------------  Spannogram (rank-%d approximation) ---------------\n', d)
n = length(A); % size of the problem (number of features)
supports = zeros(max(k), l); % will store the indices of the sparse PCs
metrics = zeros(1,l); % explained variance matrix
PCs = sparse(zeros(n,l)); % will store the extraced sparse PCs
A_temp = A; % A_temp will be deflated after each PC extraction
if d == 1 % rank-1 case (PCA+thresholding)
    for i = 1:l       
        fprintf('\nComputing sparse PC-%d\n', i)
        tic
        [q1, d1] = eigs(A_temp, 1); % compute first PC
        [temp indx] = sort(abs(q1), 'descend'); % sort
        top_k_indx = indx(1:k(i));
        supports(1:k(i),i) =  top_k_indx; % threshold
        [xsmall temp] = small_eig(A_temp, top_k_indx); % compute sparse eigenvector and its metric
        xd = sparse(zeros(n,1));
        xd(top_k_indx,:) = xsmall;
        PCs(1:k(i), i) = xd; % store PC
        metrics(i) = xd'*A*xd; % compute metric on original matrix
        A_temp = deflate(A_temp, xd, top_k_indx, dfl); % deflate matrix and repeat
        t = toc;
        fprintf('Total Computation time = %.3f sec.\n', t)
    end
elseif d>1 % rank-d case uses the constant rank solvers
    for i = 1:l
        fprintf('\nComputing sparsePC-%d\n', i)
        tic
        [Qd, Dd] = eigs(A_temp, d); % compute first d eigenvectors
        Vd = Qd*sqrt(Dd); % compute rank-d square root of A
        if elim == 1 % spannogram elimination (provably safe)
            [n_small sorted_curves] = curve_elimination(k(i)+k(i)*pos, d, Vd);
            t = toc;
            fprintf('Elimination computed in %.3f seconds\n', t)
            fprintf('%d curves left out of %d\n', n_small, length(A))
            Asmall = A_temp(sorted_curves(1:n_small),:)';
            Asmall= Asmall(sorted_curves(1:n_small),:);
        elseif elim == 0 % no elimination
            Asmall = A_temp;
            n_small = size(A_temp);
            sorted_curves = 1:n_small;
        elseif elim == 2 % row sub-samppling elimination (no provable guarantees)
            row_norms = sqrt(sum(Vd.*Vd,2));
            max_norm = max(row_norms);
            [temp sorted_curves] = sort(row_norms, 'descend');
            p = (temp)./max(temp);
            Z = rand(length(Vd),1)<p;
            n_small = sum(Z==1)
            Vd_temp = Vd(sorted_curves(find(Z==1)),:);
            Asmall = A_temp(sorted_curves(find(Z==1)),:)';
            Asmall= Asmall(sorted_curves(find(Z==1)),:)';
        end
        
        if pos == 0 % run spannogram
            if simple == 0
                [temp supports(1:k(i),i)] = rank_d_sparsePCA(k(i), Vd(sorted_curves(1:n_small),1:d), Asmall);
            else % run simple version that checks 1 candidate top-k support per intersection (2^d faster, adds d/(2k) additive error in approximation)
                [temp supports(1:k(i),i)] = rank_d_sparsePCA_simple(k(i), Vd(sorted_curves(1:n_small),1:d), Asmall);
            end
        elseif pos == 1 % run spannogram for nonnegative A (faster by a factor of 2^d)
            if simple == 0
                [temp supports(1:k(i),i)] = rank_d_sparsePCA_NN(k(i), Vd(sorted_curves(1:n_small),1:d), Asmall);
            else % run simple version that checks 1 candidate top-k support per intersection (2^d faster, adds d/(2k) additive error in approximation)
                [temp supports(1:k(i),i)] = rank_d_sparsePCA_NN_simple(k(i), Vd(sorted_curves(1:n_small),1:d), Asmall);
            end
        end
        supports(1:k(i),i) = sorted_curves(supports(1:k(i),i)); % store support
        [xsmall temp] = small_eig(A_temp, supports(1:k(i),i)); % generate k-sparse PC
        xd = sparse(zeros(length(A),1));
        xd(supports(1:k(i),i),:) = xsmall;
        PCs(:, i) = xd; % store PC
        metrics(i) = xd'*A*xd; % store metric
        A_temp = deflate(A_temp, xd, supports(1:k(i),i), dfl); % deflate matrix
        t = toc;
        fprintf('Total Computation time = %.3f sec.\n', t)
    end
end
fprintf('\n------------------------------------------------------------------\n', d)