load('compEx1data.mat');
load('compEx3data.mat');
im1 = imread('kronan1.JPG');
im2 = imread('kronan2.JPG');

n = length(x{1});

x1 = x{1};
x1(3, :) = ones(1, n);
x1 = K^(-1)*x1;

x2 = x{2};
x2(3, :) = ones(1, n);
x2 = K^(-1)*x2;

% Buld the M matrix
M = zeros(n, 9);

for i = 1:n
    xx = x2(:,i)*x1(:,i)';
    M(i,:) = xx(:)';
end

% Solve with SVD
[U, S, V] = svd(M);
v = V(:, end);
Ea = reshape(v,[3 3]);

% Veirfy minimum singular value and norm
msv = min(diag(S'*S))
nor = norm(M*v)

[U,S,V] = svd(Ea);
if det(U*V')>0
    E = U*diag([1 1 0])*V';
else
    V = -V;
    E = U*diag([1 1 0])*V';
end
E = E./E(3, 3);


% Check determinant and epipolar constaint
det = det(E)
plot(diag(x2'*E*x1));

% Compute F
F = K^(-1)'*E*K^(-1);

% Epipolar lines
l = F*x{1};
l = l./sqrt(repmat(l(1,:).^2 + l(2,:).^2,[3 1]));

% Some random points
r = randi([0, n],1,20);
xplot = zeros(3, 20);
lplot = zeros(3, 20);

for i = 1:20
    xplot(:, i) = x{2}(:, r(i));
    lplot(:, i) = l(:, r(i));
end

% Plot
figure;
imagesc(im2);
hold on;
plot(xplot(1, :), xplot(2, :), 'R.', 'MarkerSize',10);
rital(lplot);
axis equal;
hold off;

figure;
hist(abs(sum(l.*x{2})),100);

save("ce3_variables", "E");