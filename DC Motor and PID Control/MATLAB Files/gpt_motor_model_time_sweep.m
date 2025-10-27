clc; clear; close all;

%% === Motor Parameters ===
J = 0.000002;   % Rotor Inertia
B = 0.00001;    % Viscous Friction
L = 0.0005;     % Armature inductance
R = 2.0;        % Armature Resistance
K_t = 0.018;    % Torque Constant
K_e = 0.018;    % Back EMF constant

%% === Transfer Function of the Motor (Ω(s)/Ea(s)) ===
den = [(J * L), ((J * R) + (B * L)), ((B * R) + (K_e * K_t))];
num = [K_t];
G = tf(num, den)

%% === Open Loop Step Response ===
figure;
step(G);
grid on;
title('Open-Loop Step Response');
S = stepinfo(G)
dcg = dcgain(G)

%% === Bode Plot and Margins ===
figure;
bode(G);
grid on;
title('Open-Loop Bode Plot');
[GM, PM, wcg, wcp] = margin(G);
fprintf('Gain Margin = %.3g, Phase Margin = %.3g\n', GM, PM);

%% === Automated PID Control using pidtune ===
C_auto = pidtune(G, 'PID');
Kp = C_auto.Kp; Ki = C_auto.Ki; Kd = C_auto.Kd;

Tcl_auto = feedback(C_auto*G, 1);
figure;
step(Tcl_auto);
title('Closed-Loop Step Response (pidtune)');
grid on;
stepinfo(Tcl_auto)

%% === MANUAL TUNING (Ziegler–Nichols Time-Domain Sweep) ===
disp('=== Searching for Ku and Pu using time-domain sweep ===')

Ki2 = 0; Kd2 = 0;     % start with pure P control
Kp_values = logspace(2, 10, 40);   % range of Kp to test (10^2 to 10^10)
simT = 0.005;                       % total simulation time (seconds)
Ts = simT / 50000;                  % fine time resolution
t = 0:Ts:simT;
ref = ones(size(t));

best = struct('Ku', NaN, 'Pu', NaN, 'score', Inf);

for Kp2 = Kp_values
    C2 = pid(Kp2, Ki2, Kd2);
    sys_cl = feedback(C2 * G, 1);

    % Simulate closed-loop response
    y = lsim(sys_cl, ref, t);

    % Consider only steady portion
    idx0 = round(length(t) * 0.5);
    t_tail = t(idx0:end);
    y_tail = y(idx0:end);

    % Find peaks
    [pks, locs] = findpeaks(y_tail, t_tail, 'MinPeakProminence', 1e-6);
    if length(pks) < 6
        continue;  % not enough oscillations yet
    end

    % Take last 8 peaks
    N = min(8, length(pks));
    pksN = pks(end-N+1:end);
    locsN = locs(end-N+1:end);

    % Compute slope of amplitude vs time (close to 0 = sustained)
    p = polyfit(locsN, pksN, 1);
    slope = p(1);
    cov_amp = std(pksN) / mean(pksN);

    % Lower score = closer to constant oscillation
    score = abs(slope) + 10 * cov_amp;

    if score < best.score
        best.score = score;
        best.Ku = Kp2;
        best.Pu = mean(diff(locsN));
        best.slope = slope;
        best.cov = cov_amp;
    end
end

if ~isnan(best.Ku)
    fprintf('\nEstimated Ku = %.6g\nEstimated Pu = %.6g s\n', best.Ku, best.Pu);
else
    disp('Ku not found in the current range — try increasing upper limit of Kp_values.');
end

%% === Apply Ziegler–Nichols PID Formulas ===
if ~isnan(best.Ku)
    Ku = best.Ku;
    Pu = best.Pu;

    Kp_zn = 0.6 * Ku;
    Ki_zn = 2 * Kp_zn / Pu;
    Kd_zn = Kp_zn * Pu / 8;

    fprintf('\nZiegler–Nichols PID Gains:\n');
    fprintf('Kp = %.4g\nKi = %.4g\nKd = %.4g\n', Kp_zn, Ki_zn, Kd_zn);

    % Implement and Test ZN PID
    Czn = pid(Kp_zn, Ki_zn, Kd_zn);
    Tcl_zn = feedback(Czn * G, 1);

    figure;
    step(Tcl_zn);
    title('Closed-Loop Step Response (Ziegler–Nichols PID)');
    grid on;
    stepinfo(Tcl_zn)
end
