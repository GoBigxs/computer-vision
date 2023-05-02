load('compEx3.mat');
H1 = [sqrt(3) -1 1; 1 sqrt(3) 1; 0 0 2];
H2 = [1 -1 1; 1 1 0; 0 0 1];
H3 = [1 1 0; 0 2 0; 0 0 1];
H4 = [sqrt(3) -1 1; 1 sqrt(3) 1; 0.25 0.5 2];

% Add a row of ones to sp, ep
spp2 = [startpoints; ones(1,42)];
epp2 = [endpoints; ones(1,42)];

% Multiply all with H matrices
H1sp = pflat(H1 * spp2);
H1ep = pflat(H1 * epp2);
H2sp = pflat(H2 * spp2);
H2ep = pflat(H2 * epp2);
H3sp = pflat(H3 * spp2);
H3ep = pflat(H3 * epp2);
H4sp = pflat(H4 * spp2);
H4ep = pflat(H4 * epp2);

%Plots a blue line between each startpoint and endpoint
figure;
hold on
plot([startpoints(1, :); endpoints(1, :)] , ...
         [startpoints(2, :); endpoints(2, :)], 'r-', 'Color',[1, 0, 0, 0.3]);
plot([H1sp(1,:); H1ep(1,:)], [H1sp(2,:); H1ep(2,:)], 'b-');
axis equal;
figure;
hold on
plot([startpoints(1, :); endpoints(1, :)] , ...
         [startpoints(2, :); endpoints(2, :)], 'r-', 'Color',[1, 0, 0, 0.3]);
plot([H2sp(1,:); H2ep(1,:)], [H2sp(2,:); H2ep(2,:)], 'b-');
axis equal;
figure;
hold on
plot([startpoints(1, :); endpoints(1, :)] , ...
         [startpoints(2, :); endpoints(2, :)], 'r-', 'Color',[1, 0, 0, 0.3]);
plot([H3sp(1,:); H3ep(1,:)], [H3sp(2,:); H3ep(2,:)], 'b-');
axis equal;
figure;
hold on
plot([startpoints(1, :); endpoints(1, :)] , ...
         [startpoints(2, :); endpoints(2, :)], 'r-', 'Color',[1, 0, 0, 0.3]);
plot([H4sp(1,:); H4ep(1,:)], [H4sp(2,:); H4ep(2,:)], 'b-');
axis equal;