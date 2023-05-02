clear
close all

load('compEx2data.mat')

% Add a one to the coordinates
x{1} = [x{1}; ones(1, size(x{1},2))];
x{2} = [x{2}; ones(1, size(x{2},2))];

x1 = x{1};
x2 = x{2};
% Normalize
x1_norm = K^-1 * x1;
x2_norm = K^-1 * x2;

min_iter = 5;
min_corr = 5;

nbest_inls = 0;
best_inls = [];
best_E = [];

for i=1:min_iter*20
    % Random point indeces
    r = randperm(size(x1_norm, 2), min_corr);

    % Get the E matrices
    E = fivepoint_solver(x1_norm(:,r), x2_norm(:,r));
    
    for j = 1:size(E,2)
        F = (K^-1)'*E{j}*K^-1;
        
        % epipole in image 1
        l1 = pflat(F'*x2);
        l1 = l1 ./ sqrt(repmat(l1(1, :).^2 + l1(2, :).^2 ,[3 1]));

        % epipole in image 2
        l2 = pflat(F*x1);
        l2 = l2 ./ sqrt(repmat(l2(1, :).^2 + l2(2, :).^2 ,[3 1]));
        
        d1 = abs(sum(l1.*x1));
        d2 = abs(sum(l2.*x2)); 
        
        inls = (d1 < 5) & (d2 < 5);
        
        nbr_inls = sum(inls(:));
        if nbr_inls > nbest_inls
            best_E = E{j};
            nbest_inls = nbr_inls;
            best_inls = inls;
        end 
    end 
end
disp("The number of inliers = " + nbest_inls);
P1 = [eye(3) zeros(3, 1)];

W = [0 -1 0; 1 0 0; 0 0 1];
[U, ~, V] = svd(best_E);

if det(U*V') <= 0
        V = -V;
end 
% The camera 2 matrices
P2 = {[U*W*V'   U(:,3)],
     [U*W*V'  -U(:,3)],
     [U*W'*V'  U(:,3)],
     [U*W'*V' -U(:,3)]};

[P2_best, X_best] = d_infront(P1, P2, x1_norm, x2_norm);

P1 = K*P1;
P2_best = K*P2_best;
X_best = pflat(X_best);

x ={x{1}(:,best_inls==1),x{2}(:,best_inls==1)};

X_best=X_best(:,best_inls==1);

figure()
plot3(X_best(1,:), X_best(2,:), X_best(3,:), '.', 'Markersize', 2.5)
axis equal
hold on
plotcams({P1, P2_best})

P2 = P2_best;
X = X_best;

[err, res] = ComputeReprojectionError({P1, P2_best}, X_best, x);
RMS = sqrt(err/size(res,2));

figure()
hist(res,100)

save('ce2_variables', 'P1', 'P2', 'X', 'x');
