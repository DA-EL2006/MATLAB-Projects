%% 2D Transformation Demo
% Define transformation matrices
rot2d = @(theta)[cos(theta) -sin(theta) 0;
                 sin(theta)  cos(theta) 0;
                 0           0          1];

trans2d = @(tx, ty)[1 0 tx;
                    0 1 ty;
                    0 0 1];

%% Example shape (square)
pts2D = [0 0;
         20 0;
         20 20;
         0 20; 0 0];   % Nx2

% Rotation + Translation
theta = pi/2;                 % 90 degrees
R2D = rot2d(theta);
T2D = trans2d(100,200);
M2D = T2D * R2D;              % Combined transformation

% Apply transformation
pts2D_t = apply2d(M2D, pts2D);   % Nx2 result

%% Plotting
figure('Color','w'); hold on; axis equal; grid on
plot(pts2D(:,1), pts2D(:,2), 'k-o', 'LineWidth',1.5, 'DisplayName','Original')
plot(pts2D_t(:,1), pts2D_t(:,2), 'r-o', 'LineWidth',1.5, 'DisplayName','Transformed')
xlabel('X'); ylabel('Y'); title('2D Transformation Example')
legend('Location','best')

%% Verification
P = [1;0;1];           % homogeneous point (1,0)
P_t = M2D * P;         % transformed
fprintf('Check: (1,0) after rotation+translation = (%.2f, %.2f)\n', P_t(1), P_t(2));

%% -------- Local Function --------
function pts_out = apply2d(T, pts)
    % Convert Nx2 -> homogeneous, apply transform, back to Nx2
    H = T * [pts.'; ones(1, size(pts,1))];  % 3xN
    pts_out = H(1:2, :).';                  % Nx2
end
