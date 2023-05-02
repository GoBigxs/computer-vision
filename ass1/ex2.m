load('compEx2.mat');
im = imread('compEx2.JPG');
imagesc(im);
colormap gray;
hold on;

% Plot the points
plot(p1(1, :), p1(2, :), 'R+');
plot(p2(1, :), p2(2, :), 'R+');
plot(p3(1, :), p3(2, :), 'R+');

%compute the point of intersection x of the three lines
line1 = null(transpose(p1)); 
line2 = null(transpose(p2)); 
line3 = null(transpose(p3)); 

% Plot the lines
rital(line1);
rital(line2);
rital(line3);

% transpose(l)*x = 0 equations from exercies
it = pflat(null(transpose([line2 line3])));

% Plot the intersection
plot(it(1, :), it(2, :), 'G+');
axis equal;

% Distance calculated with provided formula
d = abs(transpose(line1) * [it; 1]) / sqrt(line1(1,1)^2 + line1(2,1)^2);
