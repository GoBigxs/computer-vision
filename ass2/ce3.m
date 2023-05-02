load('compEx3data.mat');
img1 = imread('cube1.JPG');
img2 = imread('cube2.JPG');

% Mean and standard deviation of the image points
meani1 = mean(x{1}(1:2,:),2);
meani2 = mean(x{2}(1:2,:),2);
stdi1 = std(x{1}(1:2,:),0,2);
stdi2 = std(x{2}(1:2,:),0,2);

% Normalization matrix for image 1
N1 = [(1/stdi1(1)) 0 -((1/stdi1(1))*meani1(1));
       0 (1/stdi1(2)) -((1/stdi1(2))*meani1(2));
       0 0 1];
   
% Normalization matrix for image 2
N2 = [(1/stdi2(1)) 0 -((1/stdi2(1))*meani2(1));
       0 (1/stdi2(2)) -((1/stdi2(2))*meani2(2));
       0 0 1];
   
% Normalize the points
N1x = N1 * x{1};
N2x = N2 * x{2};

% Plot normalized img 1 points
figure()
plot(N1x(1, :), N1x(2, :), 'B.');
figure()
plot(N2x(1, :), N2x(2, :), 'R.');
axis equal;

% Setting up the M matrix for image 1 points
M1 = p2m(N1x, Xmodel);
M2 = p2m(N2x, Xmodel);

% Singular value decomposition
[U1, S1, V1] = svd(M1);
[U2, S2, V2] = svd(M2);
% Extract v
v1 = V1(:, end);
v2 = V2(:, end);

% Eigenvalues ordered in S^TS
StS = transpose(S1)*S1;
eigenv = StS(end, end);
% Length of Mv
lmv = norm(M1*v1);

% Extract camera matrix
P1 = N1^(-1)*reshape(v1(1:12),[4 3])';
P2 = N2^(-1)*reshape(v2(1:12),[4 3])';

% Project the model points
x1 =  P1 * [Xmodel; ones(1, length(Xmodel))];
x2 =  P2 * [Xmodel; ones(1, length(Xmodel))];
x1 = pflat(x1);
x2 = pflat(x2);

% Plot 1
figure;
imagesc(img1);
hold on;
plot(x{1}(1, :), x{1}(2, :), 'G*');
plot(x1(1, :), x1(2, :), 'R.', 'MarkerSize',10);
axis equal;

% Plot 2
figure;
imagesc(img2);
hold on;
plot(x{2}(1, :), x{2}(2, :), 'G*');
plot(x2(1, :), x2(2, :), 'R.', 'MarkerSize',10);
axis equal;

% 3d Plot
P = cell(1,2);
P{1} = P1;
P{2} = P2;
figure;
plot3([Xmodel(1,startind); Xmodel(1,endind)], [Xmodel(2,startind); Xmodel(2,endind)], [Xmodel(3,startind); Xmodel(3,endind)],'b-');
hold on;
plotcams(P);
axis equal;

% Inner parameters of cameras
K1 = rq(P1(1:3,1:3));
K1 = K1./K1(3,3)
K2 = rq(P2(1:3,1:3));
K2 = K2./K2(3,3)


function [M] = p2m(x,X)
% Create M matrix from X and x
n = length(X);
M = zeros(3*n, 12+n);

for i=1:n
    Xi = [X(:, i); 1];
    xi = x(:, i);
    
    for j=1:3
        M(3*i-3+j, j*4-3:j*4) = transpose(Xi);
    end
    
    M(3*i-2:3*i, 12+i) = -xi;
end

end