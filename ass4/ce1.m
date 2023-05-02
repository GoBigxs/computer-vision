clear
close all
addpath("vlfeat-0.9.21/toolbox");
vl_setup;

A = imread('a.jpg');
B = imread('b.jpg');

[fA dA] = vl_sift(single(rgb2gray(A)));
[fB dB] = vl_sift(single(rgb2gray(B)));

[matches, scores] = vl_ubcmatch(dA, dB);

xA = [fA(1:2, matches(1,:)); ones(1, size(matches,2))];
xB = [fB(1:2, matches(2,:)); ones(1, size(matches,2))];

best_H = [];
threshold = 5;
min_corr = 4;

for i=1:30
    % Random point indeces
    r = randperm(size(xA, 2), min_corr);
    % Pick the points
    rxA = xA(:,r);
    rxB = xB(:,r);
    %creating the M matrix
    M = zeros(3*size(rxA,2), 3*size(rxA,1)+min_corr);
    
    row = 1;
    col = 3*size(rxA,1)+1;
    
    for j=1:size(rxA, 2)
        n = size(rxA,1);
        m = [rxA(:,j)'    zeros(1,2*n); 
             zeros(1,n)  rxA(:,j)' zeros(1,n); 
             zeros(1, 2*n)        rxA(:,j)'];  
         M(row:row+2, 1:9) = m;
         M(row:row+2, col) = -rxB(:,j);
         
         row = row + 3;
         col = col + 1;
    end
    
    [U, S, V] = svd(M);
    v = V(:, end);
    H = [v(1:3)'; v(4:6)'; v(7:9)'];
    
    txA = zeros(size(xA));
    for j=1:size(xA,2)
        txA(:,j) = pflat(H*xA(:,j));
    end 
    
    inls = sqrt(sum((txA(1:2,:) - xB(1:2,:)).^2))<5;
    nbr_inls = sum(inls(:) == 1);

    if nbr_inls > threshold
        best_H = H;
        threshold = nbr_inls;
    end 
end

Htform = projective2d(best_H');

Rout = imref2d(size(A), [-200 800], [-400 600]);
%Sets the size and output bounds of the new image.

[Atransf] = imwarp(A, Htform, 'OutputView', Rout);
%Transforms the image

Idtform = projective2d (eye(3));
[Btransf] = imwarp(B, Idtform, 'OutputView', Rout);
%Creates a larger version of the second image

AB = Btransf;
AB(Btransf < Atransf) = Atransf(Btransf < Atransf);
%Writes both images in the new image. %(A somewhat hacky solution is needed 
%since pixels outside the valid image area are not allways zero...)
imagesc(Rout.XWorldLimits, Rout.YWorldLimits ,AB);
%Plots the new image with the correct axes