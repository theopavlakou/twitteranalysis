function Adfl = deflate(A, x, supp, type)
Idiag = [1:length(A)];
Isparse = sparse(Idiag, Idiag, 1);
if type == 0 % zero-forcing deflation 
    Adfl = A;
    Adfl(:,supp) = 0;
    Adfl = Adfl';
    Adfl(:,supp) = 0;    
elseif type == 1 % projection deflation
    P = Isparse-x*x';
    Adfl = P*A*P;   
elseif type == 2 % Schur complement deflation
    Adfl = A-A*x*x'*A/(x'*A*x);    
end

