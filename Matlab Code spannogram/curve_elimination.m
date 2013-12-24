%[n_small sorted_curves] = curve_elimination(k, d, V)
%--------------------------------------------------------------------------
%Curve elimination for the spannogram algorithm.
%Version 1.0
%Date: 21/06/2013
%
%Input:
%   k: levels of sparsity for each PC, e.g. k = [5, 4, 3, 2, 5]
%   d: accuracy parameter (the rank of the approximation)
%      (d: 1 is PCA+thresholding, 
%       d: 2,3, usually perform near optimally, with d=2 being much faster)
%   V: nxd matrix
%Output: 
%   n_small: the number of features left after the elimination
%   sorted_curve: a list of the curves after the elimination sorted by
%   amplitude
%--------------------------------------------------------------------------
function [n_small sorted_curves] = curve_elimination(k, d, V)
n = length(V);
d = size(V,2);
% If it does not stop after MAX_ITER iterations, it empirically takes time more than the algorithm itself
if d==3
    MAX_ITER = 150;
elseif d>3
    MAX_ITER = 100;
else
    MAX_ITER = 1000;
end
% sort curves by amplitude
max_amp = zeros(n,1);
max_amp = sqrt(sum(V.*V,2));
[temp sorted_curves] = sort(max_amp, 'descend');
% find the minimum of the k-blanket for the first k+d curves
Vtemp = V(sorted_curves(1:k+d),:);
C = intersection_vectors(k, Vtemp);
% find which interesection points belong to the k-blanket
C_blanket = blanket_intersection_vectors(k, C, Vtemp);
[temp indx] = min(C_blanket(end,:));
C_blanket_min = temp; % then save the minimum of this boundary
iter = 1;
flag = 0;
n_small = length(Vtemp);
while (iter<MAX_ITER & n_small<n & C_blanket_min<max_amp(sorted_curves(n_small)) )    
    % for each new curve in the list of sorted ones, we generate its
    % intersection points with the curves checked before it.
    n_small = n_small+1;
    Vtemp = V(sorted_curves(1:n_small),:);
    % calculate intersection points for new curve
    C_new = compute_curve_intersections(k, Vtemp);
    % the new points to check if they belong in the new k-blanket are: the
    % points of the previous blanket and the new intersection points
    C = [C_blanket(1:end-1,:) C_new];
    % check if interesection points belong to the k blanket
    C_blanket = blanket_intersection_vectors(k, C, Vtemp);
    [temp indx] = min(C_blanket(end,:)); % find the new minimum
    C_blanket_min = temp;
    iter = iter+1;
end
C_blanket_min
for i = 1:n
    if (C_blanket_min>max_amp(sorted_curves(i)) || i>MAX_ITER)
        n_small = i-1;
        break
    end
end
if n_small>n
    n_small = n;
end






