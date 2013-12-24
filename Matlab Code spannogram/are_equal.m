function [ equal ] = are_equal(A, B)
%% Returns if 2 vectors/matrices/scalars are equal. 
    if size(A, 1) ~= size(B, 1);
        equal = 0;
        return;
    end
    if size(A, 2) ~= size(B, 2);
        equal = 0;
        return;
    end
    for i = 1:size(A, 1);
        for j = 1:size(A, 2);
            if A(i, j) ~= B(i, j);
                equal = 0;
                return;
            end
        end
    end
    equal = 1;
    return;
end

