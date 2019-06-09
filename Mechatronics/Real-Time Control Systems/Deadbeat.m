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
Ac = [0 1; -(w^2)-kf -2*Xi*w];
Bc = [0; gss*ku];
Cc = [1 0];
Dc = 0;
sys = ss(Ac,Bc,Cc,Dc);

%Linearized Discrete Model
sysd = c2d(sys, Ts);
G = tf(sysd); %Transfer Function G(z)
[A,B,C,D] = ssdata(sysd); %Discrete Time Model Parameters [A,B,C,D]
[z,p,k] = zpkdata(sysd,'v'); %Zeros/Poles of DT model



%Deadbeat - Christopher Ohara

% Prep work from linearization
%K=-acker(A,B,p);
%L=acker(A',C',p)'; % Does not like dimensionality
%poles = [0.2 0.2 0.2];
%A = [0.0007 0 0; -5.2051 0.0006 0; -1 0 1];
%B = [0.0001; 1.1804; 0];
%C = [1 0 0];
%poles = [0.0 0.0 0.0];


% Derived before Controller I and linearization (use for validation)
%A= [1 1.001 0; 0 0.860 0; -1 0 1];
%B= [14100; 13100; 0];
%C= [1 0 0];
%Mc = [14100 27185 38440; 13085 11250 9675; 0 14100 41300];
%P = Mc';
%K = acker(A, B, poles); % Ackermann equation
%e3 = [0 14100 41300]; % Third row of Mc 
%L= K'; 
%K0 = -0.0663;
%K1 = [0.1369 0.0710];

% Implemented for consistency in report
Ad = [0.7 0 0; -5205.1 0.6 0; -1 0 1];
Bd= [1; 11804; 0];
Cd= [1 0 0];
Mc = [1 0.7 0.5;11804 1877.3 -2517.2;0 -1 -1.7];
P = Mc';
poles = [0.0 0.0 0.0];
K = acker(Ad, Bd, poles); % Ackermann equation
e3 = [0 14100 41300]; % Third row of Mc 
L= K'; 
K0 = -2.5;
K1 = [1.3018 0.0001];


open('Deadbeat_Sim')
T=0:0.15:0.45;
sim('Deadbeat_Sim',T)

scopes = find_system(bdroot,'BlockType','Scope');


