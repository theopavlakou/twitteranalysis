function [ S ] = loadSparseMatrix( file_name, rows, columns )
%% Loads a sparse matrix from a file in the following format:
%  <row_number>, <column_entry>, <column_entry>, ...
%  <row_number>, <column_entry>, <column_entry>, ...
%  where column entry indicates a 1
    tic;
    file_in = fopen(file_name);

    S = sparse(rows, columns);
    while ~feof(file_in)
        line = fgetl(file_in);
        
        x = str2num(line);
        % if there is more than just a row number
        if(size(x, 2) > 1)
            % get the row number
            row_number = x(1);
            disp(row_number);
            % add to separate lists row_vec.append(x(1)),
            % col_vec.append(x(i)), and then create another vectore of
            % size, col_vec, with only ones.
            for i = 2:size(x, 2)
                S(row_number, x(i)) = 1; 
            end
        end
    end

end

