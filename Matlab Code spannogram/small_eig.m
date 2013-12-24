function [q lambda] = small_eig(A, indx)
q = zeros(size(A));
lambda = zeros(size(A));
[q lambda] = eig(full(A(indx,indx)));
q = q(:,end);
lambda = lambda(end,end);