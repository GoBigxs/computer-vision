load('compEx4.mat');

P1 = K * [R1 t1];
P2 = K * [R2 t2];

% Camera centers
cc1 = pflat(null(P1));
cc2 = pflat(null(P2));

% Principal axes
pa1 = P1(3,1:3);
pa2 = P2(3,1:3);

% Flatten U for plot
Uf = pflat(U);

% 3D plot
plot3(Uf(1,:), Uf(2,:), Uf(3,:), '.', 'Markersize', 2);
hold on;
quiver3(cc1(1), cc1(2), cc1(3), pa1(1), pa1(2), pa1(3), 5);
quiver3(cc2(1), cc2(2), cc2(3), pa2(1), pa2(2), pa2(3), 5);
axis equal;

% Project with camera matrix, plot
UP1 = pflat(P1 * U);
figure;
im = imread('assignment1data/compEx4im1.JPG');
imagesc(im);
colormap gray;
hold on;
plot(UP1(1, :), UP1(2, :), 'b.');

% Project with camera matrix, plot
UP2 = pflat(P2 * U);
figure;
im = imread('assignment1data/compEx4im2.JPG');
imagesc(im);
colormap gray;
hold on;
plot(UP2(1, :), UP2(2, :), 'b.');

pa1n = pa1 ./ sqrt(pa1(1)^2 + pa1(2)^2 + pa1(3)^2)
pa2n = pa2 ./ sqrt(pa2(1)^2 + pa2(2)^2 + pa2(3)^2)