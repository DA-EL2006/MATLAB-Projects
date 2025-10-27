s = tf('s')
G = 10/(s+1)/(s+2)/(s+3)/(s+4);
step(G);
k = dcgain(G);

L = 0.846; T = 3.15-L;
[Gc1, Kp1] = ziegler(1, [k, L, T, 10]);
[Gc2, Kp2, Ti2] = ziegler(2, [k, L, T, 10]);
[Gc3, Kp3, Ti3, Td3] = ziegler(3, [k, L, T, N, 10]);