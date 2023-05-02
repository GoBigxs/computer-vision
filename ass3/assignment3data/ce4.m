clear
close all

load("ce3_variables.mat")
load("ce1_variables.mat")
load("compEx1data.mat")
load('compEx3data.mat')

im1 = imread("kronan1.jpg");
im2 = imread("kronan2.jpg");

P1 = [eye(3,3) zeros(3,1)];
P = cameraE(E);

% M matrix
x1norm=K^(-1)*x{1};
x2norm = K^(-1)*x{2};

[P_best,X]=infront(P,x,x1norm,x2norm);

P1 = K * P1;
P_best = K * P_best;

xproj1 = pflat(P1*X);
xproj2= pflat(P_best*X);

X = pflat(X);


figure()
imagesc(im1)
hold on
plot(xproj1(1,:),xproj1(2,:),'r*');
plot(x{1}(1,:),x{1}(2,:),'bo');

figure()
imagesc(im2);
hold on
plot(xproj2(1,:),xproj2(2,:),'r*');
plot(x{2}(1,:),x{2}(2,:),'bo');


figure()
plot3(X(1,:),X(2,:),X(3,:),'.','Markersize',2)
axis equal
hold on
plotcams({P_best,P1})