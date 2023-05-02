clear
close all
% Load matched 2D points from two images
load('ex6.mat'); % contains two variables: points1 and points2

% Define the camera matrices
P1 = K*[eye(3), zeros(3,1)];
P2 = K*[R, t];

im1 = imread('ex6_im1.jpg');
im2 = imread('ex6_im2.jpg');

n = estimate_plane_normal(P1, P2, x1a, x2a, x1b, x2b);

function n = estimate_plane_normal(P1, P2, x1a, x2a, x1b, x2b)
% Estimate the normal vector of a plane from corresponding points
% using the given camera matrices P1 and P2.

% Construct the matrices A and b
A = [x1a(1)*P1(3,:) - P1(1,:);
    x1a(2)*P1(3,:) - P1(2,:);
    x1b(1)*P2(3,:) - P2(1,:);
    x1b(2)*P2(3,:) - P2(2,:)];

b = [-x2a(1);
    -x2a(2);
    -x2b(1);
    -x2b(2)];

% Solve the linear equation system
x = A \ b;

% Extract the normal vector
n = x(1:3) / norm(x(1:3));
end

