function [y] = pflat(x)
    [m, n] = size(x);
    div = x(end, :);
    % Create division matrix
    divm = repmat(div, [m-1 1]);
    % Remove last row
    x = x(1:m-1, :);
    % Element-wise division
    y = x ./divm;
end