addpath("vlfeat-0.9.21\toolbox");
vl_setup;
im1 = imread('cube1.JPG');
im2 = imread('cube2.JPG');

% Compute sift features
[f1 d1] = vl_sift( single(rgb2gray(im1)), 'PeakThresh', 1);
[f2 d2] = vl_sift( single(rgb2gray(im2)), 'PeakThresh', 1);

% Match the descriptors
[matches ,scores] = vl_ubcmatch(d1,d2);

% Extract matching points
x1 = [f1(1,matches(1,:));f1(2,matches(1,:))];
x2 = [f2(1,matches(2,:));f2(2,matches(2,:))];

% Select 10 matches, plot lines between the matching points
perm = randperm(size(matches ,2)); figure;
imagesc([im1 im2]);
hold on;
plot([x1(1,perm(1:10)); x2(1,perm(1:10))+size(im1,2)], [x1(2,perm(1:10)); x2(2,perm(1:10))],'-');
axis equal;
hold off;