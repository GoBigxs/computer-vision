load ce3and4.mat

% DLT equations for all points
n = length(x1);
z = zeros(3, 1);
X = zeros(4, n);

% x1 = pflat(inv(K1)*[x1; ones(1, n)]);
% x2 = pflat(inv(K2)*[x2; ones(1, n)]);
% P1 = inv(K1)*P1;
% P2 = inv(K2)*P2;

%solving the triangulation problem by with DLT
for i = 1:n
    M = [P1 -[x1(:, i); 1] z; P2 z -[x2(:, i); 1]];
    [U, S, V] = svd(M);
    v = V(:, end);
    X(:, i) = v(1:4, 1);
end

% Project the points
xp1 = pflat(P1*X);
xp2 = pflat(P2*X);

% Plot the projections
figure;
imagesc(img1);
hold on;
plot(x1(1,:), x1(2,:), 'R*');
plot(xp1(1,:), xp1(2,:), 'B.');
axis equal;
hold off;

figure;
imagesc(img2);
hold on;
plot(x2(1,:), x2(2,:), 'R*');
plot(xp2(1,:), xp2(2,:), 'G.');
axis equal;
hold off;


% Remove points with large error
good_points = (sqrt(sum((x1-xp1(1:2,:)).^2)) < 3 & sqrt(sum((x2-xp2(1:2,:)).^2)) < 3);
X = pflat(X(:, good_points));

% Plot the lot
figure;
plot3(X(1, :), X(2, :), X(3, :), 'B.');
hold on;
plot3([Xmodel(1,startind); Xmodel(1,endind)], [Xmodel(2,startind); Xmodel(2,endind)], [Xmodel(3,startind); Xmodel(3,endind)],'b-');
plotcams(P);
