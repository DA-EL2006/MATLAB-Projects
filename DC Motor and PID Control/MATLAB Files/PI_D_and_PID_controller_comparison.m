
G=tf(1,[1,3,3,1]);Ti=1;Td=1;Kp=1;N=10;s=tf('s');
 Gc=Kp*(1+1/Ti/s+Td*s/(1+Td*s/N));
 G_c=feedback(G*Gc,1);Gc1=Kp*(1+1/s/Ti);
 H=((1+Kp/N)*Ti*Td*s^2+Kp*(Ti+Td/N)*s+Kp)/(Kp*(Ti*s+1)*(Td/N*s+1));
 G_c1=feedback(G*Gc1,H);step(G_c,G_c1)


