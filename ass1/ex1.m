load('compEx1.mat');

a = pflat(x2D);
b = pflat(x3D);

%Plots a point at (a(1,i),a(2,i)) for each i.
figure;
plot(a(1, :), a(2, :), '.');
axis equal;

%Same as above but 3D.
figure;
plot3(b(1 ,:), b(2 ,:), b(3 ,:) , '.');
axis equal;
