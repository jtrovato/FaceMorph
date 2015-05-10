function [a1, ax, ay, w] = est_tps(ctr_pts, target_value)

U = @(r) r.^2.*log(r.^2); %function for the radial basis function

p = size(ctr_pts, 1);
lambda = 0.0000001;
ctr_pts_mat_x = repmat(ctr_pts(:,1), [1, p]) - repmat(ctr_pts(:,1)', [p, 1]);
ctr_pts_mat_y = repmat(ctr_pts(:,2), [1, p]) - repmat(ctr_pts(:,2)', [p, 1]);

K = U(sqrt(ctr_pts_mat_x.^2 + ctr_pts_mat_y.^2));
K(isnan(K)) = 0;

P = [ctr_pts, ones(p,1)];

tps_mat = [K, P; P', zeros(3,3)] + lambda.*eye(p+3, p+3);

tps_coef = tps_mat\[target_value;0;0;0];

w = tps_coef(1:p);
ax = tps_coef(p+1);
ay = tps_coef(p+2);
a1 = tps_coef(p+3);