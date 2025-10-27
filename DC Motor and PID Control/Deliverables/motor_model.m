%Placeholder for values for the motor
J = 0.000002;  %Rotor Inertia
B = 0.00001;   %Viscous Friction
L = 0.0005;    %Armature inductance
R = 2.0;      %Armature Resistance
K_t = 0.018;   %Torque Constant
K_e = 0.018;   %Back EMF constant

den = [(J * L), ((J * R) + (B * L)), ((B * R) + (K_e * K_t))]; %Denominator
num = [K_t];  %Numerator

G = tf(num, den)   %Transfer function of Omega(Ohms)/ Ea(Armature Voltage)


%Open-Loop Step Response Graph
figure;
step(G);
grid on;
title('Open-Loop Step Response');
dcg = dcgain(G)   %steady state gain record

%Open-Loop Step Response Bode Diagram
figure;
bode(G);
grid on;
[GM, PM, wcg, wcp] = margin(G);

%Automated PID control using pidtune
C = pidtune(G, 'PID');  %returns a PID object tuned  for a default bandwidth
Kp = C.Kp;
Ki = C.Ki;
Kd = C.Kd;
stepinfo(C);

%Simulation Closed-Loop
Tcl = feedback(C*G, 1);  %unity feedback
figure;
step(Tcl);
grid on;
stepinfo(Tcl)


%Manual (Ziegler Nichols Method)
Ki2 = 0;
Kd2 = 0;
Kp2 = 700;
C2 = pid(Kp2, Ki2, Kd2);

%Diagram
Tcl2 = feedback(C2*G, 1);
figure;
step(Tcl2);
grid on;
stepinfo(Tcl2)
open_system('DC_motor.slx')




