num = [1];
den = [1 3 3 1];
G = tf(num, den);
for Kp = [0.1:0.1:1], H = feedback(Kp*G, 1);
    step(H), hold on;
end
figure;
rlocus(G, [0,15])

Kp = 1; s = tf('s');
for Ti = [0.7:0.1:1.5]
    Gc = Kp*(1+1/Ti/s);
    G_c = feedback(G*Gc, 1);
    step(G_c); hold on;
end

Kp = 1; Ti = 1;
for Td = [0.1:0.2:2.2]
    Gc = Kp*(1+1/Ti/s+Td*s);
    Y = feedback(G*Gc, 1);
    step(Y); hold on;
end

Td = 1;
Gc = Kp*(1+1/Ti/s+Td*s);
step(feedback(G*Gc, 1)), hold on;
for N = [100, 1000, 10000, 1:10]
   Gc = Kp*(1+1/Ti/s+Td*s/(1+Td*s/N ));
   step(feedback(G*Gc, 1));
end
figure;
[y,t] = step(feedback(G*Gc, 1));
err = 1-y;
plot(t, err)
