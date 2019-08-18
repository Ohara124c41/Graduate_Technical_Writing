clear;clc;close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Raumfahrtsysteme                                     %%%%%%%%%%%%%%%%%
%%%% Gruppe Mechanic                                      %%%%%%%%%%%%%%%%%
%%%% 05.03.2019                                           %%%%%%%%%%%%%%%%%
%%%% Maurer,D., Klioner, E., Berger,R., Block,N.          %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Color Order for plots
ColLimit     = [0.6 0.6 0.6];    % Grenzen, grey
ColOrder_new = [...
    0.3010    0.7450    0.9330   % Zustand 1, light blue
    0         0.4470    0.7410   % Zustand 2, blue
    0.4940    0.1840    0.5560   % Zustand 3, violet
    0.6650    0.0780    0.1840   % Zustand 4, dark red
    0.9500    0.3750    0.0980   % Zustand 5, orange
    0.9290    0.6940    0.1250   % Zustand 6, dark yellow
    0.4660    0.6740    0.1880   % Zustand 7, light green
    0.2660    0.4740    0.3880]; % Zustand 8, dark green
% Change to new colors for all plots
set(gca, 'ColorOrder', ColOrder_new, 'NextPlot', 'replacechildren');
LineWidth = 1; % linewidth for all plots

%% Startwerte und Variationen
m=65.4;                                             %kg
m_v=80:-5:50;                                       %kg
C = 0.5;                                            %cw Wert standard
cw = 0.5:0.1:1;                                     %cw variation
rho= 1.111;                                         %Dichte auf 1000m Höhe in kg/m^3 
rho_v = [1.111 1.134 1.156 1.179 1.202 1.2247];     %kg/m^3
theta=79;                                           %Inklinationdeg
theta_v = 90:-5:60;                                 %deg 
v=120;                                              %m/s
v_v = 140:-10:90;                                   %m/s
A=pi*(0.10)^2+pi*(0.075)^2+pi*(0.075)^2;            %m^2
g=9.81;                                             %m/s^2 (acceleration due to gravity)
delta_t=.001;                                       %s

%% Variation des cw-Wertes

for j=1:5
    D=rho*cw(j)*A/2;
    y=0;
    y2=0;
    i=1;
    x(1)=0;
    y(1)=0;
    vx=v*cosd(theta);
    vy=v*sind(theta);
    t_W(1,j)=0; 
    while min(y)> -.001
        ax=-(D/m)*(vx*vx+vy*vy)^0.5*vx;
        ay=-g-(D/m)*(vx*vx+vy*vy)^0.5*vy;
        vx=vx+ax*delta_t;
        vy=vy+ay*delta_t;
        x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
        y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
        t_W(i+1,j)=t_W(i,j)+delta_t;
        V_W2(i,j)=(vx^2+vy^2)^(1/2);
        i=i+1;
    end
    V_W2(i,j)=(vx^2+vy^2)^(1/2);
end
     
for j=2:5
     i=1;
     while V_W2(i,j)~= 0
         Ende(j) = i;
         i=i+1;
     end
end
figure('units','normalized','position',[0,0,0.5,1]); 
hold on
h_plot(1)= plot(t_W(:,1),V_W2(:,1),'-','linewidth',1.5,'Color', ColOrder_new(1+1,:));
h_plot(2)= plot(t_W(1:Ende(2),2),V_W2(1:Ende(2),2),'-','linewidth',1.5,'Color', ColOrder_new(2+1,:));
h_plot(3)= plot(t_W(1:Ende(3),3),V_W2(1:Ende(3),3),'-','linewidth',1.5,'Color', ColOrder_new(3+1,:));
h_plot(4)= plot(t_W(1:Ende(4),4),V_W2(1:Ende(4),4),'-','linewidth',1.5,'Color', ColOrder_new(4+1,:));
h_plot(5)= plot(t_W(1:Ende(5),5),V_W2(1:Ende(5),5),'-','linewidth',1.5,'Color', ColOrder_new(5+1,:));
xlabel('Zeit [s]')
ylabel('Geschwindigkeit [m/s]')
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5)],['cw = 0,5'],...
['cw = 0,6'],['cw = 0,7'],['cw = 0,8'],['cw = 0,9'],'location','northeast');
grid on
close figure 1
print -dpng Flugbahn_var_cw.png -r500 

clear ax ay i j t_W v_W2 x y y2 Ende V_W2 vx vy
%% Variation der Dichte
for j=1:6
    D=rho_v(j)*C*A/2;
    y=0;
    y2=0;
    i=1;
    x(1)=0;
    y(1)=0;
    vx=v*cosd(theta);
    vy=v*sind(theta);
    t_W(1,j)=0; 
        while min(y)> -.001
            ax=-(D/m)*(vx*vx+vy*vy)^0.5*vx;
            ay=-g-(D/m)*(vx*vx+vy*vy)^0.5*vy;
            vx=vx+ax*delta_t;
            vy=vy+ay*delta_t;
            x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
            y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
            t_W(i+1,j)=t_W(i,j)+delta_t;
            V_W2(i,j)=(vx^2+vy^2)^(1/2);
            i=i+1;
         end
    V_W2(i,j)=(vx^2+vy^2)^(1/2);
end
     
for j=2:6
    i=1;
    while V_W2(i,j)~= 0
        Ende(j) = i;
        i=i+1;
    end
end
figure('units','normalized','position',[0,0,0.5,1]); 
hold on
h_plot(1)= plot(t_W(:,1),V_W2(:,1),'-','linewidth',1.5,'Color', ColOrder_new(1+1,:));
h_plot(2)= plot(t_W(1:Ende(2),2),V_W2(1:Ende(2),2),'-','linewidth',1.5,'Color', ColOrder_new(2+1,:));
h_plot(3)= plot(t_W(1:Ende(3),3),V_W2(1:Ende(3),3),'-','linewidth',1.5,'Color', ColOrder_new(3+1,:));
h_plot(4)= plot(t_W(1:Ende(4),4),V_W2(1:Ende(4),4),'-','linewidth',1.5,'Color', ColOrder_new(4+1,:));
h_plot(5)= plot(t_W(1:Ende(5),5),V_W2(1:Ende(5),5),'-','linewidth',1.5,'Color', ColOrder_new(5+1,:));
h_plot(6)= plot(t_W(1:Ende(6),6),V_W2(1:Ende(6),6),'-','linewidth',1.5,'Color', ColOrder_new(6+1,:));
legend('Mit Luftwiderstand', 'Ohne Widerstand')
xlabel('Zeit [s]')
ylabel('Geschwindigkeit [m/s]')
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['H = 1000m'],...
['H = 800m'],['H = 600m'],['H = 400m'],['H = 200m'],['H = 0m'],'location','northeast');
grid on

print -dpng Flugbahn_var_rho.png -r500 

clear ax ay i j t_W v_W2 x y y2 Ende V_W2 vx vy
%% Variation der Inklination

for j=1:6
    D=rho*C*A/2;
    y=0;
    y2=0;
    i=1;
    x(1)=0;
    y(1)=0;
    theta=theta_v(j); %deg
    vx=v*cosd(theta);
    vy=v*sind(theta);
    t_W(1,j)=0; 
    while min(y)> -.001
        ax=-(D/m)*(vx*vx+vy*vy)^0.5*vx;
        ay=-g-(D/m)*(vx*vx+vy*vy)^0.5*vy;
        vx=vx+ax*delta_t;
        vy=vy+ay*delta_t;
        x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
        y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
        t_W(i+1,j)=t_W(i,j)+delta_t;
        V_W2(i,j)=(vx^2+vy^2)^(1/2);
        i=i+1;
     end
    V_W2(i,j)=(vx^2+vy^2)^(1/2);
    end
      
for j=2:6
    i=1;
    while V_W2(i,j)~= 0
         Ende(j) = i;
         i=i+1;
    end
end
figure('units','normalized','position',[0,0,0.5,1]); 
hold on
h_plot(1)= plot(t_W(:,1),V_W2(:,1),'-','linewidth',1.5,'Color', ColOrder_new(1+1,:));
h_plot(2)= plot(t_W(1:Ende(2),2),V_W2(1:Ende(2),2),'-','linewidth',1.5,'Color', ColOrder_new(2+1,:));
h_plot(3)= plot(t_W(1:Ende(3),3),V_W2(1:Ende(3),3),'-','linewidth',1.5,'Color', ColOrder_new(3+1,:));
h_plot(4)= plot(t_W(1:Ende(4),4),V_W2(1:Ende(4),4),'-','linewidth',1.5,'Color', ColOrder_new(4+1,:));
h_plot(5)= plot(t_W(1:Ende(5),5),V_W2(1:Ende(5),5),'-','linewidth',1.5,'Color', ColOrder_new(5+1,:));
h_plot(6)= plot(t_W(1:Ende(6),6),V_W2(1:Ende(6),6),'-','linewidth',1.5,'Color', ColOrder_new(6+1,:));
xlabel('Zeit [s]')
ylabel('Geschwindigkeit [m/s]')
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['i = 90°'],...
['i = 85°'],['i = 80°'],['i = 75°'],['i = 70°'],['i = 65°'],'location','northeast');
grid on
print -dpng Flugbahn_var_i.png -r500 

clear ax ay i j t_W v_W2 x y y2 Ende V_W2 vx vy
%% Variation der Masse

theta = 79;
for j=1:6
    D=rho*C*A/2;
    y=0;
    y2=0;
    i=1;
    x(1)=0;
    y(1)=0;
    vx=v*cosd(theta);
    vy=v*sind(theta);
    t_W(1,j)=0; 
        while min(y)> -.001
            ax=-(D/m_v(j))*(vx*vx+vy*vy)^0.5*vx;
            ay=-g-(D/m_v(j))*(vx*vx+vy*vy)^0.5*vy;
            vx=vx+ax*delta_t;
            vy=vy+ay*delta_t;
            x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
            y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
            t_W(i+1,j)=t_W(i,j)+delta_t;
            V_W2(i,j)=(vx^2+vy^2)^(1/2);
            i=i+1;
         end
    V_W2(i,j)=(vx^2+vy^2)^(1/2);
end
  
for j=2:6
     i=1;
     while V_W2(i,j)~= 0
         Ende(j) = i;
         i=i+1;
        if i == 20317
             AMK = 0;
         end
     end
end
figure(1)
figure('units','normalized','position',[0,0,0.5,1]); 
hold on
h_plot(1)= plot(t_W(:,1),V_W2(:,1),'-','linewidth',1.5,'Color', ColOrder_new(1+1,:));
h_plot(2)= plot(t_W(1:Ende(2),2),V_W2(1:Ende(2),2),'-','linewidth',1.5,'Color', ColOrder_new(2+1,:));
h_plot(3)= plot(t_W(1:Ende(3),3),V_W2(1:Ende(3),3),'-','linewidth',1.5,'Color', ColOrder_new(3+1,:));
h_plot(4)= plot(t_W(1:Ende(4),4),V_W2(1:Ende(4),4),'-','linewidth',1.5,'Color', ColOrder_new(4+1,:));
h_plot(5)= plot(t_W(1:Ende(5),5),V_W2(1:Ende(5),5),'-','linewidth',1.5,'Color', ColOrder_new(5+1,:));
h_plot(6)= plot(t_W(1:Ende(6),6),V_W2(1:Ende(6),6),'-','linewidth',1.5,'Color', ColOrder_new(6+1,:));
xlabel('Zeit [s]')
ylabel('Geschwindigkeit [m/s]')
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['m = 50kg'],...
['m = 55kg'],['m = 60kg'],['m = 65kg'],['m = 70kg'],['m = 75kg'],'location','northeast');
grid on
print -dpng Flugbahn_var_m.png -r500 

clear ax ay i j t_W v_W2 x y y2 Ende V_W2 vx vy
%% Variation der Anfangsgeschwindigkeit

 for j=1:6
     D=rho*C*A/2;
     y=0;
     y2=0;
     i=1;
     x(1)=0;
     y(1)=0;
     v=v_v(j); %m/s
     vx=v*cosd(theta);
     vy=v*sind(theta);
     t_W(1,j)=0; 
        while min(y)> -.001
            ax=-(D/m)*(vx*vx+vy*vy)^0.5*vx;
            ay=-g-(D/m)*(vx*vx+vy*vy)^0.5*vy;
            vx=vx+ax*delta_t;
            vy=vy+ay*delta_t;
            x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
            y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
            t_W(i+1,j)=t_W(i,j)+delta_t;
            V_W2(i,j)=(vx^2+vy^2)^(1/2);
            i=i+1;
         end
    V_W2(i,j)=(vx^2+vy^2)^(1/2);
end

for j=2:6
         i=1;
    while V_W2(i,j)~= 0
         Ende(j) = i;
         i=i+1;
    end
end
figure('units','normalized','position',[0,0,0.5,1]); 
hold on
h_plot(1)= plot(t_W(:,1),V_W2(:,1),'-','linewidth',1.5,'Color', ColOrder_new(1+1,:));
h_plot(2)= plot(t_W(1:Ende(2),2),V_W2(1:Ende(2),2),'-','linewidth',1.5,'Color', ColOrder_new(2+1,:));
h_plot(3)= plot(t_W(1:Ende(3),3),V_W2(1:Ende(3),3),'-','linewidth',1.5,'Color', ColOrder_new(3+1,:));
h_plot(4)= plot(t_W(1:Ende(4),4),V_W2(1:Ende(4),4),'-','linewidth',1.5,'Color', ColOrder_new(4+1,:));
h_plot(5)= plot(t_W(1:Ende(5),5),V_W2(1:Ende(5),5),'-','linewidth',1.5,'Color', ColOrder_new(5+1,:));
h_plot(6)= plot(t_W(1:Ende(6),6),V_W2(1:Ende(6),6),'-','linewidth',1.5,'Color', ColOrder_new(6+1,:));
xlabel('Zeit [s]')
ylabel('Geschwindigkeit [m/s]')
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['V_0 = 140 m/s'],...
['V_0 = 130 m/s'],['V_0 = 120 m/s'],['V_0 = 110 m/s'],['V_0 = 100 m/s'],['V_0 = 90 m/s'],'location','northeast');
grid on

print -dpng Flugbahn_var_v0.png -r500 

%% Standard Parameter
D=rho*C*A/2;
y=0;
y2=0;
i=1;
x(1)=0;
y(1)=0;
v=120; %m/s
vx=v*cosd(theta);
vy=v*sind(theta);
t_W(1,j)=0; 
while min(y)> -.001
    ax=-(D/m)*(vx*vx+vy*vy)^0.5*vx;
    ay=-g-(D/m)*(vx*vx+vy*vy)^0.5*vy;
    vx=vx+ax*delta_t;
    vy=vy+ay*delta_t;
    x(i+1)=x(i)+vx*delta_t+.5*ax*delta_t^2;
    y(i+1)=y(i)+vy*delta_t+.5*ay*delta_t^2;
    t_W(i+1,j)=t_W(i,j)+delta_t;
    V_W2(i,j)=(vx^2+vy^2)^(1/2);
    i=i+1;
end
V_W2(i,j)=(vx^2+vy^2)^(1/2);
    
figure('units','normalized','position',[0,0,0.5,1]);
hold on
h_plot(1)= plot(t_W(:,1),V_W2(:,1),'-','linewidth',1.5,'Color', ColOrder_new(1+1,:));
xlabel('Zeit [s]')
ylabel('Geschwindigkeit [m/s]')
grid on
print -dpng Flugbahn_standard.png -r500 
