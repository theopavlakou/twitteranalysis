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
l=1;
k=[4,3];
d=2;
dfl=1;
pos=1;
simple=1;
A=rand(30,30);
elim=1;
[PCs, supports, metrics] = spannogram_sparsePCA(l, k, d, A, dfl, pos, elim, simple);
