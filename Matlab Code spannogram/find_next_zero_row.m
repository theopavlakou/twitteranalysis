function [ next_zero_index ] = find_next_zero_row( B, last_zero_index)
%% Returns the integer value of the index of the next row that is fully equal to
%  zero in the matrix B, starting from the index provided.
    for i = last_zero_index:size(B, 1);
        if are_equal(B(i, :), zeros(1, size(B, 2))) == 1;
            next_zero_index = i;
            return;
        else
            i = i + 1;
        end
    end
    next_zero_index = -1;

end

