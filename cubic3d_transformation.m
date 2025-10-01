%Rotation and Translation functions

%rotation about x-axis
rot_x = @(a)[1 0 0 0;
            0 cos(a) -sin(a) 0;
            0 sin(a) cos(a) 0;
            0 0 0 1];

%rotation about y-axis
rot_y = @(a)[cos(a) 0 -sin(a) 0;
             0 1 0 0;
             sin(a) 0 cos(a) 0;
             0 0 0 1];

%rotation about z-axis
rot_z = @(a)[cos(a) -sin(a) 0 0;
            sin(a) cos(a) 0 0;
            0 0 1 0;
            0 0 0 1];

%translation function
trans3d = @(tx,ty,tz)[1 0 0 tx;
                      0 1 0 ty;
                      0 0 1 tz;
                      0 0 0 1];

%Example Shape(Cube)
edges = [1 2; 2 3; 3 4; 4 1;
        5 6; 6 7; 7 8; 8 5;
        1 5; 2 6; 3 7; 4 8];

Cube3D = [-100 -100 -100;
          100 -100 -100;
          100 100 -100;
         -100 100 -100;
         -100 -100 100;
          100 -100 100;
          100 100 100;
          -100 100 100];

for i = 1:size(edges, 1)
plot3([Cube3D(edges(i,1),1), Cube3D(edges(i,2),1)], ...
      [Cube3D(edges(i,1),2), Cube3D(edges(i,2),2)], ...
      [Cube3D(edges(i,1),3), Cube3D(edges(i,2),3)], 'k-', 'LineWidth',1.5);
end


%Transformation: rotate + translate
theta = pi/4;
R3D = rot_x(theta) * rot_y(theta);
T3D = trans3d(100, 200, 50);
M3D = R3D * T3D;

%Apply transformation
Cube3D_t = apply3d(M3D, Cube3D);

for i = 1:size(edges, 1)
plot3([Cube3D_t(edges(i,1),1), Cube3D_t(edges(i,2),1)], ...
      [Cube3D_t(edges(i,1),2), Cube3D_t(edges(i,2),2)], ...
      [Cube3D_t(edges(i,1),3), Cube3D_t(edges(i,2),3)], 'r-', 'LineWidth',1.5);
end

%Plot
figure('Color', 'w');
hold on;
axis equal; 
grid on;
plot3(Cube3D(:,1), Cube3D(:,2), Cube3D(:,3), 'k-o', 'LineWidth',1.5, 'DisplayName','Original')
plot3(Cube3D_t(:,1), Cube3D_t(:,2), Cube3D_t(:,3), 'r-o', 'LineWidth',1.5, 'DisplayName','Transformed')
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Cube Transformation');
legend('Location', 'best')


%Apply Transformation Function
function pts_out = apply3d(T, pts)
H = T * [pts.'; ones(1, size(pts,1))];
pts_out = H(1:3,:).';
end


