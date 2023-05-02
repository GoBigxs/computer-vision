load('compEx1data.mat');

% Plot the 3D reconstruction points
figure()
hold on;
plot3(X(1, :), X(2, :), X(3, :), '.');
% Plot the principal axis of all cameras
plotcams(P);
axis equal;

% Project X with P1
proj = P{1} * X;
% Find visible points in image 1
visible1 = isfinite (x{1}(1 ,:));
% Multiple visible with projections
projv = visible1 .* proj;
% Set zeros to = NaN to not draw invisible points
projv(projv==0) = NaN;

% Plot the image
figure;
imagesc(imread(imfiles{1}));
hold on;
% pflat the projection points and plot
pp = pflat(projv);
plot(x{1}(1, :), x{1}(2, :), 'B*');
plot(pp(1, :), pp(2, :),  'G.');
axis equal;

% The two transformations
T1 = [1 0 0 0;
    0 4 0 0;
    0 0 1 0;
    1/10 1/10 0 1];
XT1 = T1 * X;
XT1 = pflat(XT1);

for i = 1:length(P)
    PT1{i} = P{i} * T1^(-1);
end

figure;
plot3(XT1(1, :), XT1(2, :), XT1(3, :), '.');
hold on;
plotcams(PT1);
axis equal;

T2 = [1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    1/16 1/16 0 1];
XT2 = T2 * X;
XT2f = pflat(XT2);

for i = 1:length(P)
    PT2{i} = P{i} * T2^(-1);
end

figure;
plot3(XT2f(1, :), XT2f(2, :), XT2f(3, :), '.');
hold on;
plotcams(PT2);
axis equal;

% Project new T2 points with a new T2 camera
xT2 = PT2{1} * XT2;
vis = isfinite (x{ 1 }(1 ,:));
xT2v = vis .* xT2;
xT2v(xT2v==0) = NaN;

% Plot the image
figure;
imagesc(imread(imfiles{1}));
hold on;
% pflat the projection points and plot
pp = pflat(xT2v);
plot(x{1}(1, :), x{1}(2, :), 'B*');
plot(pp(1, :), pp(2, :),  'G.');
axis equal;

% PT1, PT2 are the cameras transformed with T1/2
format short
K1 = rq(PT1{1})
K2 = rq(PT2{2})