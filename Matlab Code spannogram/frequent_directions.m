function [B] = frequent_directions(l, S)
%% Implements the frequent directions algorithm described in "Simple and
%  Deterministic Matrix Sketching" by Edo Liberty. An input matrix file
%  S is inputted which is R^(m x n). The resulting matrix is a matrix of 
%  size R^(l x n), where l << m. This implementation only works for l < n.
    tic;
    file_in = fopen(S);
    line = fgetl(file_in);
    x = str2num(line);  
    cols = size(x, 2);
    B = zeros(l, cols);
    last_zero_index = 1;
    while ~feof(file_in);
      %disp(B)
      % Find a row in B that is only zeros and replace it with the row x
      last_zero_index = find_next_zero_row(B, last_zero_index);
      if last_zero_index == -1;
          %fprintf('Got here\n');
          last_zero_index = 1;
          [~, Sigma, V] = svd(B,'econ');
          delta = Sigma(ceil(l/2), ceil(l/2))^2;
          %disp(B);
          %Sigma_hat = zeros(size(Sigma, 1), size(Sigma, 2));
          %Sigma_hat(1:l, 1:l) = sqrt(max(Sigma(1:l, 1:l).^2 - diag(delta*ones(1, l)), 0));
          Sigma_hat = sqrt(max(Sigma.^2 - diag(delta*ones(1, l)), 0));
          %fprintf('Before: \n');
          %disp(B);
          %fprintf('Sigma_hat\n');
          %disp(Sigma_hat);          
          %fprintf('V^T\n');
          %disp(V');
          %fprintf('After\n');

          B = Sigma_hat*V';
          %disp(B);
      else
          B(last_zero_index, :) = x;
      end
      line = fgetl(file_in);
      x =  str2num(line);    % get row index of S
    end
    fclose(file_in);
    toc;
end