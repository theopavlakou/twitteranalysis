%% A script to explain PCA

X = zeros(21, 2);
for i = -10:10
X(i+11,:) = [i, i+(4*rand()-2)];
end

subplot(3, 1,1);
plot(X(:,1), X(:, 2), '*r');
hold all;
plot([-15, 15], [-15, 15], 'b');
axis([-15, 15, -15, 15])
xlabel('Feature 1');
ylabel('Feature 2');
title('Feture Plot Before PCA');

subplot(3,1,2);
coeffs = pca(X);
X_subspace = X*coeffs;
plot(X_subspace(:,1), X_subspace(:, 2), '*r');
hold all;
axis([-15, 15, -15, 15])
plot([-15 15], [0 0], 'b');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('Feture Plot After PCA Projecting Onto Both Principal Components');

subplot(3,1,3);
coeffs = pca(X);
X_subspace = X*coeffs(:, 1);
plot(X_subspace(:,1), 0, '*r');
hold all;
axis([-15, 15, -15, 15])
plot([-15 15], [0 0], 'b');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('Feture Plot After PCA Projecting Onto One Principal Component');
