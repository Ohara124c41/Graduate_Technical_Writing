clear;clc;
%Matlab Code for Part I and II of ECE664 Project (2018)
%Group 1 - Austin Shields
w = 3518.59; %Natural Frequency
Xi = 0.21; %Damping Ratio
ku = 101.8; %Gain Constant
kf = 4.987E7; %Gain Constant
gss = 1.3867E6; % Steady-State Gain
Ts = 0.0001; %10Khz sampling

%Linearized Continuous Model
Ad = [0 1; -(w^2)-kf -2*Xi*w];
Bd = [0; gss*ku];
Cd = [1 0];
Dd = 0;
sys = ss(Ad,Bd,Cd,Dd);



% Plant discrete-time state soace model:
% x(n+1) = Ad*x(n) + Bd*u(n)
% y(n) = Cd*x(n) + Dd*u(n)
%
% Input : - Ad, Bd, Cd, Dd
% - 'ir_poles' is desired poles, for example, [0.1, 0.1, 0.1]
% Output: K1 - gain vector for state feedback
% Ki - gain for the integrator
% 1. Determine P matrix
Ai = [Ad [0; 0]; -Cd 1]; Bi = [Bd; 0];
Mc = [Bi Ai*Bi Ai^2*Bi];
iMc = inv(Mc);
e3t = iMc(3, :);
P = [e3t; e3t*Ai; e3t*Ai^2];
ir_poles = [0.2 0.2 0.2];

% 2. Open-Loop Characteristic Poly:
% z^3 + (a2)z^2 + (a1)z + a0
tmp = eig(Ai);
tmp0 = conv([1 -tmp(1)], [1 -tmp(2)]);
tmp0 = conv(tmp0, [1 -tmp(3)]);
a0 = tmp0(4); a1 = real(tmp0(3)); a2 = tmp0(2);
% 3. Closed-Loop Characteristic Poly:
% z^3 + (s2)z^2 + (s1)z + s0
tmp = ir_poles;
tmp1 = conv([1 -tmp(1)], [1 -tmp(2)]);
tmp1 = conv(tmp1, [1 -tmp(3)]);
s0 = tmp1(4); s1 = tmp1(3); s2 = tmp1(2);
Kr = [s0-a0 s1-a1 s2-a2]*P;
K1 = Kr(1, 1:2);
Ki = Kr(1, 3);

% Plant discrete-time state space model:
% x(n+1) = Ad*x(n) + Bd*u(n)
% y(n) = Cd*x(n) + Dd*u(n)
%
% Input : - Ad, Cd.
% - 'p_poles' is desired close loop plant poles,
% for examples, [0.2, 0.2].
% Output: L - the observer gain

% 1. Determine Q matrix
Mo = [Cd; Cd*Ad];
iMo = inv(Mo);
h2 = [iMo(:, 2)];
Q = [h2 Ad*h2];
p_poles = [0.2, 0.2];
% 2. Open-Loop Characteristic Poly:
% z^2 + (a1)z + a0
tmp = eig(Ad);
tmp1 = conv([1 -tmp(1)], [1 -tmp(2)]);
a0 = tmp1(3); a1 = tmp1(2);
% 3. Observer Characteristic Poly:
% z^2 + (b1)z + (b0)z
Ts = 0.0001;
temp = min(p_poles);
ramda_c = log(temp)/Ts; ramda_d = exp(2*ramda_c*Ts);
tmp2 = conv([1 -ramda_d], [1 -ramda_d]);
b0 = tmp2(3); b1 = tmp2(2);
L = Q*[b0-a0; b1-a1];


open('Deadbeat_Sim')
T=0:0.15:0.45;
sim('Deadbeat_Sim',T)

scopes = find_system(bdroot,'BlockType','Scope');
