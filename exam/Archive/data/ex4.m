clear
close all

load('ex4.mat')
im = imread("ex4.jpg");

x = [x; ones(1, size(x,2))];
X = [X; ones(1, size(X,2))];

x_mean = mean(x(1:2,:),2);
x_std = std(x(1:2,:),0,2);

N = norm_matrix(x_mean, x_std);
norm_x = N*x;

min_iter = 118;
min_corr = 6;

nbest_inls = 0;
best_inls = [];
best_E = [];

for i=1:min_iter
    % Random point indeces
    r = randperm(size(norm_x, 2), min_corr);
    rx = x(:,r);
    rX = X(:,r);
    M = zeros(3*size(rx,2), 3 * 4 + 6);
    row = 1;
    for i = 1:6
        col = 1;
        for j = 1:3
            M(row, col : col + 3) = rX(:,i)';
            row = row + 1;
            col = col + 4;
        end
        M(i*3-2 : i*3, 12+i) = -rx(:,i);
    end
    % Solve for the camera matrix using SVD
    [U, ~, V] = svd(M);

    if det(U*V') <= 0
        V = -V;
    end 
    
    P_hom = V(:, end);

    % Reshape the homogenous camera matrix to 3x4 matrix
    Pt = reshape(P_hom(1:12), 4, 3)';

    P = inv(N) * Pt;

    A = zeros(3, size(X,2));
    for k = 1:size(X,2)
        A(:,k) = pflat(Pt * X(:,k));
    end

    inliers = sqrt(sum((A(1:2,:) - x(1:2,:)).^2))<5;
    nbr_inl = sum(inliers);
    if nbr_inl > nbest_inls
        best_E = P;
        nbest_inls = nbr_inl;
        best_inls = inliers;
    end
end


X_best = X(:, best_inls==1);
figure()
plot3(X_best(1,:), X_best(2,:), X_best(3,:), '.', 'Markersize', 2.5)
axis equal
hold on
%%

C = null(best_E);
center = C(1:3)/C(4);
q = -best_E(3,1:3);
plot3(center(1,:), center(2,:), center(3,:),'r*');
quiver3(center(1), center(2), center(3), q(1), q(2), q(3), 20000);




function N = norm_matrix(mean_xy, std_xy)
    s = 1./std_xy;
    N = [s(1)   0       -s(1)*mean_xy(1);
         0      s(2)    -s(2)*mean_xy(2);
         0      0       1];
end 

