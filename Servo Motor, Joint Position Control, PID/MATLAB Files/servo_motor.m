%Servo Motor Control.l
%Parameters Definition 
J = 0.01;  %Inertia
b = 0.001;  %Viscous damping
Kt = 0.05;   % Torque constant
Ke = 0.05;  %Back EMF constant
R = 2;    %Armature resistance

%Getting the Transfer Function
num = [Kt/R];
den= [J (b+((Kt*Ke)/R))];

G = tf(num, den);

pole(G)
bandwidth(G) 

%PID Controller.
H = pidtune(G, 'PID');
Kp = H.Kp;
Ki = H.Ki;
Kd = H.Kd;

%Checking the step, bode and margin plots
figure;
step(G);
grid on;
title('Open Loop Step Response');
S = stepinfo(G);
dcg = dcgain(G);

%Margin plot a.k.a Bode Plot
figure;
title('Margin- gain and phase margin diagram ')
margin(G);
grid on;

%Closed Loop Graphing
Tcl = feedback(H*G, 1);   % closed-loop transfer (1 for unity feedback)
figure;
step(Tcl);
grid on;   
info = stepinfo(Tcl);   % rise time, settling time, overshoot
p = pole(Tcl);                 % closed-loop poles
bw = bandwidth(Tcl);           % closed-loop bandwidth
margin(H*G)                   % open-loop margins