function [B] = loadLineByLine(fileName);
%% Returns the matrix S'*S when the file is 
    tic;
    fin = fopen(fileName);
    index = 1;
    set = false;
%     S = load(fileName);
    while ~feof(fin)

      line = fgetl(fin);
%       disp('Got here');
%        disp(index);
      x =  str2num(line);    % get row index of S
      index = index + 1;

%       disp(x);
      if (norm(x) < 1.5)
          continue;
      end
%       disp('Got here');

      if (set == false);
%         disp('Got here too');

        B = zeros(size(x, 2), size(x, 2));
        set = true;
      end
      B = x'*x + B;
    end
    fclose(fin);
    toc;
end