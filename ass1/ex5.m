clear all
load CompEx5.mat
im = imread('CompEx5.jpg');
%% draw the corners of the image
subplot(1,2,1);
colormap('gray');
imagesc(im);
hold on
plot(corners(1,[1:end 1]), corners(2,[1:end 1]), '*-');
axis equal

% normalize the corners
new_corners = inv(K) * corners;
subplot(1,2,2);
plot(new_corners(1,[1:end 1]), new_corners(2,[1:end 1]), '*-');
axis ij
axis equal
%% use the equation in Ex6
v = v./v(4);
s = zeros(1,4);
for i = 1:4
    s(i) = -v(1:3)' * new_corners(1:3,i);
end
U = [new_corners; s]; 
I = [1 0 0 0; 0 1 0 0; 0 0 1 0];
P1 = K * I; % camera matrix
% calculate camera center and pricipal axis
C = null(P1);
center = C(1:3)/C(4);
pa = P1(3,1:3);
plot3(U(1,[1:end 1]), U(2,[1:end 1]), U(3,[1:end 1]), '*-');
hold on
plot3(center(1,:), center(2,:), center(3,:),'r*');
quiver3(center(1), center(2), center(3), pa(1), pa(2), pa(3));
% calculate new camera's center and principal axis
Rt = [sqrt(3)/2 0 0.5 2; 0 1 0 0; -0.5 0 sqrt(3)/2 0];
P2 = K*Rt;
center2 = [2;0;0];
pa2 = P2(3,1:3);
plot3(center2(1,:), center2(2,:), center2(3,:),'r*');
quiver3(center2(1), center2(2), center2(3), pa2(1), pa2(2), pa2(3));
axis equal
%% draw new corners in 2D using formula in Ex6
R = [sqrt(3)/2 0 0.5; 0 1 0; -0.5 0 sqrt(3)/2];
t = [2;0;0];
H = R - t * v(1:3)';
y = H*new_corners;
y = pflat(y);
plot(y(1,[1:end 1]), y(2,[1:end 1]), '*-');
axis equal
axis ij
%% draw new corners in 3D
yn = [y; s];
plot3(yn(1,[1:end 1]), yn(2,[1:end 1]), yn(3,[1:end 1]), '*-');
hold on
plot3(center2(1,:), center2(2,:), center2(3,:),'r*');
quiver3(center2(1), center2(2), center2(3), pa2(1), pa2(2), pa2(3));
axis equal
%% draw the final image
Htot = K*H*inv(K);
tform = maketform('projective',Htot');
[new_im,xdata,ydata] = imtransform(im,tform,'size',size(im));
colormap('gray');
imagesc(xdata,ydata,new_im);
axis equal
%% new camera matrix
P2