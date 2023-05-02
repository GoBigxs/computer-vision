load('compEx1.mat');

a = pcalc(x2D);
b = pcalc(x3D);

[m, n] = size(x3D);
%Extracts the last row of x
div = x3D(end, :);
% Create division matrix
divm = repmat(div, [m-1 1]);
% Remove last row
c = x3D(1:m-1, :);
% Element-wise division
y = c./divm;

%Plots a point at (a(1,i),a(2,i)) for each i.
figure;
plot(a(1, :), a(2, :), '.');
axis equal;

%Same as above but 3D.
figure;
plot3(b(1 ,:), b(2 ,:), b(3 ,:) , '.');
axis equal;

function [Y] = pcalc(X)
    %dim = size(X, 1);
    %len = length(X);
    [m, n] = size(X);
    Y = [];
    
    for i = 1:n
        Y = [Y pflat(X(:, i))];
    end
    
    % Remove last row
    Y = Y(1:m-1, :);
end

function [y] = pflat(x)
    [m, n] = size(x);
    %Extracts the last row of x
    div = x(end, :);
    % Create division matrix
    divm = repmat(div, [m-1 1]);
    % Remove last row
    x = x(1:m-1, :);
    % Element-wise division
    y = x./divm;
end