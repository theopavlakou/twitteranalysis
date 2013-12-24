%C = find_curve_intersections(k, Vtemp)
%--------------------------------------------------------------------------
%Finds the vectors tha solve the equation v_n=...=v_id for all d
%collections of curves, with one of them always being the n-th curve. These
%are exactly the new intersection points added by considering an extra
%curve (the n-th one).
%
%Version 1.0
%Date: 21/06/2013
%
%Input:
%   k: levels of sparsity for each PC, e.g. k = [5, 4, 3, 2, 5]
%   Vtemp: nxd matrix
%Output: 
%   C: (d+1)x(n-1 choose d) matrix where each column is a vector that
%   corresponds to an intersection of d curves. The last element of each
%   column corresponds to one of the curves in the intersection.
%--------------------------------------------------------------------------
function C = find_curve_intersections(k, Vtemp)
d = size(Vtemp,2);
n = size(Vtemp,1);
combs = nchoosek(1:n-1, d-1);
C = zeros(d+1,size(combs,1));
p = 1;
for i = 1:size(combs,1)
    V_inter = Vtemp([n combs(i,:)],:);
    signs = [-ones(2^(d-1),1) 2*(dec2bin(0:2^(d-1)-1)-48)-1];    
    for j=1:size(signs,1)
        V_inter_signed = diag(signs(j,:))*V_inter;
        [temp1 temp2 Vr] = svd(V_inter_signed(2:end,:)-kron(ones(d-1,1),V_inter_signed(1,:)));
        c_inter = Vr(:, end);
        C(:,p) = [c_inter; combs(i,1)];% store the intersection vector and one of the intersecting curves
        p = p+1;
    end
end

