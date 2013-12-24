% Load the matrix from the file
%load '/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitteranalysis/S';
% Get the matrix that is meant to be used by the spannogram_sparsePCA
% method
S = loadSparseMatrix('S', 37000, 3000);
%A = S'*S;
A = S'*S;
% Make A a hollow matrix
for i=1:length(A)
    A(i, i) = 0;
end
% Run method
[PCs, supports, metrics] = spannogram_sparsePCA(2, [6, 6], 2, A, 2, 1, 1, 1);