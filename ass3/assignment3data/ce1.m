clc
clear all
close all
load compEx1data.mat
im1 = imread("kronan1.JPG");
im2 = imread("kronan2.JPG");

% Normalization
N1 = normMatrix(x{1});
N2 = normMatrix(x{2});

%N1 = eye(3,3);
%N2 = eye(3,3);

% Normalize the points
norm_x1 = N1 * x{1};
norm_x2 = N2 * x{2};

% Construct M matrix

M = zeros(size(norm_x1,2), 9);

for i=1:size(norm_x1,2)
    r = norm_x2(:,i) * norm_x1(:,i)';
    M(i,:) = r(:)';
end 

% Compute normalized F matrix
[U, S, V] = svd(M);
v = V(:,end);

norm(M*v, 2);
F_t = reshape(v, [3 3]);

% Compute F matrix
[Ut, St, Vt] = svd(F_t);
St(3,3) = 0;
det(F_t); % very close to 0
norm_x2(:,1)'*F_t*norm_x1(:,1);

F_t = Ut * St * Vt';
figure();
plot(diag(norm_x2'*F_t*norm_x1));


F = N2'*F_t*N1;
F = F ./ F(3,3);

% epipolar lines
l = F*x{1};
l = l./ sqrt(repmat(l(1, :).^2 + l(2, :).^2 ,[3 1]));

% histogram
figure();
histogram(abs(sum(l.*x{2})),100);

% random points and lines
r = randi([1 size(norm_x1, 2)],1,20);
p = x{2}(:,r);
figure();
set(3,'DefaultLineLineWidth',1)
imagesc(im2);
hold on
rital(l(:,r));
plot(p(1,:), p(2,:), 'c*')



d = mean(abs(sum(l.*x{2})));

save("ce1_variables", "F", "N1", "N2", "F_t");
        
function f = normMatrix(x)
m = mean(x(1:2,:),2);
s  = std(x(1:2,:),0,2);
f = [1/s(1) 0 -m(1)/s(1);
    0 1/s(2) -m(2)/s(2);
    0  0 1];
end