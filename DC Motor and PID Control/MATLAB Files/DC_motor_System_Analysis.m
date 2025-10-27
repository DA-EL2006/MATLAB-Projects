%Placeholder for values for the motor
J = 0.01;  %Rotor Inertia
B = 0.1;   %Viscous Friction
L = 0.5;    %Armature inductance
R = 1.0;      %Armature Resistance
K =  0.01;   %Torque Constant
s = tf('s');
P_motor = K/((J*s+B)*(L*s+R)+K^2);

linearSystemAnalyzer('step', P_motor, 0:0.1:5);