function [ L ] = getLaplacian( S )
    % Make the adjacency matrix, A.
    % Any non-zero elements should become 1 (logicals)
    A = logical(S'*S);
    for i = 1:length(A);
        A(i, i) = 0;
    end
    % Make the degree matrix, D.
    d = sum(A, 1);
    D = diag(d, 0);
    % Make Laplacian matrix, L.
    L = D - A;
end

